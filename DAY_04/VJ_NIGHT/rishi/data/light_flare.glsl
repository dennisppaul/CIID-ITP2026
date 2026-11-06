#ifdef GL_ES
precision highp float;
precision highp int;
#endif
#define PROCESSING_TEXTURE_SHADER
uniform sampler2D texture;
uniform vec2 uTexel;       // 1 / source width, 1 / source height.
uniform float uStrength;   // 0..1; the sketch supplies the musical pulse.
uniform float uTransition; // 0 normally, 1 at a full-colour bridge.
varying vec4 vertTexCoord;

vec3 lightSample(vec2 uv, inout float low, inout float high) {
  vec3 c = texture2D(texture, clamp(uv, vec2(0.0), vec2(1.0))).rgb;
  float value = max(c.r, max(c.g, c.b));
  low = min(low, value);
  high = max(high, value);
  return c * smoothstep(0.44, 0.88, value);
}

void main() {
  vec2 uv = vertTexCoord.st;
  float low = 1.0, high = 0.0;
  vec3 centre = lightSample(uv, low, high);
  // A small soft halo, plus short horizontal/vertical rays from existing light.
  vec3 soft = centre * 4.0;
  soft += lightSample(uv + uTexel*vec2(10.0, 10.0), low, high);
  soft += lightSample(uv + uTexel*vec2(-10.0, 10.0), low, high);
  soft += lightSample(uv + uTexel*vec2(10.0, -10.0), low, high);
  soft += lightSample(uv + uTexel*vec2(-10.0, -10.0), low, high);
  vec3 rays = centre * 2.0;
  rays += lightSample(uv + uTexel*vec2(4.0, 0.0), low, high);
  rays += lightSample(uv - uTexel*vec2(4.0, 0.0), low, high);
  rays += lightSample(uv + uTexel*vec2(0.0, 4.0), low, high);
  rays += lightSample(uv - uTexel*vec2(0.0, 4.0), low, high);
  rays += 0.65*lightSample(uv + uTexel*vec2(8.0, 0.0), low, high);
  rays += 0.65*lightSample(uv - uTexel*vec2(8.0, 0.0), low, high);
  rays += 0.65*lightSample(uv + uTexel*vec2(0.0, 8.0), low, high);
  rays += 0.65*lightSample(uv - uTexel*vec2(0.0, 8.0), low, high);
  rays += 0.35*lightSample(uv + uTexel*vec2(14.0, 0.0), low, high);
  rays += 0.35*lightSample(uv - uTexel*vec2(14.0, 0.0), low, high);
  rays += 0.35*lightSample(uv + uTexel*vec2(0.0, 14.0), low, high);
  rays += 0.35*lightSample(uv - uTexel*vec2(0.0, 14.0), low, high);
  rays += 0.15*lightSample(uv + uTexel*vec2(22.0, 0.0), low, high);
  rays += 0.15*lightSample(uv - uTexel*vec2(22.0, 0.0), low, high);
  // Flat colours and shader grain are not light sources. Keep the bridge intact.
  float contrast = smoothstep(0.10, 0.28, high-low);
  float bridge = 1.0-smoothstep(0.55, 1.0, uTransition);
  vec3 flare = (soft/8.0*0.22 + rays/10.3*0.34) * contrast;
  gl_FragColor = vec4(flare * clamp(uStrength, 0.0, 1.0) * bridge, 1.0);
}
