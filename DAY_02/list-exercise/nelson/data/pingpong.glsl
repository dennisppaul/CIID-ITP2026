#ifdef GL_ES
precision mediump float;
#endif
#define PROCESSING_TEXTURE_SHADER
#define PI acos(-1.)

uniform sampler2D uTexture;
uniform float uTime;
uniform vec2 texOffset;
uniform vec2 uResolution;
uniform float uAmplitude;
uniform float uEnergy;
uniform float uBeatCounter;

vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d ) {
  return a + b*cos( PI*2. * (c*t + d) );
}

void main() {
  float time = uTime * 0.01;
  vec2 uv = gl_FragCoord.xy / uResolution;
  uv.y /= uResolution.x / uResolution.y;
  vec2 _uv = uv;
  vec3 tex = texture2D(uTexture, uv).rgb;

  vec3 color = vec3(0.);

  float circle = length(_uv);
  circle = 1. - step(uEnergy, circle);
  // circle *= uEnergy;

  float val = 2.;
  vec2 id = floor(_uv * val);
  vec2 fd = fract(_uv * val);

  // color = vec3(circle);
  // color = mix(vec3(circle), tex, 0.5);
  // for (float i = 0.; i < 5.; i++) {
  //   if (mod(id.x, 5.) == i || mod(id.y, 5.) == i) {
  //     color = vec3(i / 5.);
  //   }
  // }

  if (mod(id.x, val) == 0. || mod(id.y, val) == 0.) {
    color = vec3(uEnergy * 10.);
  } else if (mod(id.x, val) == 1. || mod(id.y, val) == 1.) {
    color = vec3(uAmplitude);
  } else {
    // color = vec3(0.);
  }


  gl_FragColor = vec4(color, 1.0);
}
