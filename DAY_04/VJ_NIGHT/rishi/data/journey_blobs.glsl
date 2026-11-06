#ifdef GL_ES
precision highp float;
precision highp int;
#endif
#define PROCESSING_TEXTURE_SHADER
uniform sampler2D texture;
uniform vec2 resolution;
uniform vec4 circles[18];
uniform vec4 seeds[64];
uniform float seedFade[64];
uniform float uZoom, uRotation;
uniform vec3 colours[6];
uniform float uMerge, uKaleido, uGrain, uFold;
uniform vec4 rings[12];
uniform float uRingMix, uFlood;
varying vec4 vertTexCoord;

vec3 palette(float heat) {
  vec3 c = colours[0];
  c = mix(c, colours[1], smoothstep(0.0, 0.08, heat));
  c = mix(c, colours[2], smoothstep(0.08, 0.25, heat));
  c = mix(c, colours[3], smoothstep(0.25, 0.48, heat));
  c = mix(c, colours[4], smoothstep(0.48, 0.65, heat));
  return mix(c, colours[5], smoothstep(0.65, 0.94, heat));
}

float speckle(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// A shared soft field makes neighbouring shapes join and separate.
float blob(vec2 p, vec2 centre, float radius) {
  vec2 d = (p-centre)/max(radius*(1.0+uFlood*3.5), 0.001);
  float dd = dot(d,d);
  return 0.76*exp(-1.4*dd)+0.24*exp(-6.0*dd);
}

vec2 mirrorSix(vec2 p) {
  float sector = 6.28318530718/6.0;
  float a = mod(atan(p.y,p.x)+uRotation,sector);
  a = min(a,sector-a);
  return length(p)*vec2(cos(a),sin(a));
}

void main() {
  vec2 p = (gl_FragCoord.xy-resolution*0.5)/resolution.y;
  float openingField = 0.0;
  if (uKaleido < 0.5 && uRingMix < 1.0 && uFlood < 1.0) {
    // Start with the exact circles from the opening, without a position jump.
    for (int i=0; i<18; i++) {
      if (circles[i].z > 0.001) openingField += 1.2*blob(p,circles[i].xy,circles[i].z);
    }
  }

  float mirroredField = 0.0, cold = 0.0;
  if (uKaleido > 0.5 && uRingMix < 1.0 && uFlood < 1.0) {
    vec2 q = mirrorSix((p+vec2(0.0,uFold*0.5))/(1.0+uFold*0.45))/uZoom;
    // VJBlobs 4 field: independent moving cells, not a fixed ring of seeds.
    for (int i=0; i<64; i++) {
      if (seedFade[i]<=0.001) continue;
      vec2 d = abs(q-seeds[i].xy)/max(seeds[i].z*(1.0+uFlood*3.5),0.001);
      if (max(d.x,d.y)>3.0) continue;
      float distance = mix(length(d),d.x+d.y,seeds[i].w);
      float weight = mix(0.8,1.6,smoothstep(0.04,0.22,seeds[i].z));
      float value = seedFade[i]*weight*exp(-1.4*distance*distance);
      mirroredField += value;
      cold += value*seeds[i].w;
    }
  }
  // One geometry at a time; exchange only under the exact same full colour.
  float field = uKaleido>0.5 ? mirroredField : openingField;
  float crisp = cold/max(mirroredField,0.00001);
  float heat = pow(clamp(field,0.0,1.0),mix(0.85,1.6,crisp*uKaleido));
  vec3 colour = palette(mix(heat,1.0,uFlood));
  float grain = speckle(gl_FragCoord.xy)+speckle(gl_FragCoord.xy+13.7)-1.0;
  colour += grain*uGrain*0.32*(1.0-uFlood);

  if (uRingMix > 0.001) {
    float r = length(p);
    float wave = 0.0;
    for (int i=0; i<12; i++) {
      if (rings[i].z==0.0) continue;
      float edge = (r-rings[i].x)/max(rings[i].y*(1.0+uFlood*4.0),0.001);
      wave += exp(-edge*edge)*rings[i].z;
    }
    float iris = exp(-pow((r-0.035)/0.014,2.0));
    float ringHeat = clamp(wave*1.6+iris*1.05,0.0,1.0);
    vec3 ringColour = palette(pow(mix(ringHeat,1.0,uFlood),0.85));
    ringColour = mix(colours[0]*0.08,ringColour,mix(smoothstep(0.012,0.022,r),1.0,uFlood));
    ringColour += grain*uGrain*0.12*(1.0-uFlood);
    colour = mix(colour,clamp(ringColour,0.0,1.0),uRingMix);
  }
  vec3 opening = uMerge < 1.0 ? texture2D(texture,vertTexCoord.st).rgb : vec3(0.0);
  gl_FragColor = vec4(mix(opening,clamp(colour,0.0,1.0),uMerge),1.0);
}
