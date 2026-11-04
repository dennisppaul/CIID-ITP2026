#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 uResolution;
uniform float uTime;

varying vec2 vUv;

/* 
  SCENE
 */

vec3 path(in float delta) {
  return vec3(
    cos(delta*.1) * 2.2 + sin((delta) * .3) * .5*cos(delta * .05),
    sin(delta * .05) * 6.4 + cos(delta * .04) * 6.4,
    delta
  );
}

mat3 calcLookAtMatrix( in vec3 ro, in vec3 tar, in float roll ) {
  vec3 ww = normalize( tar - ro );
  vec3 uu = normalize( cross(ww,vec3(sin(roll),cos(roll),0.0) ) );
  vec3 vv = normalize( cross(uu,ww));
  return mat3( uu, vv, ww );
}

float map( in vec3 p ) {
  float acc = 1000.;
  // float an = atan( p.y, p.x );
  // float fft = texture2D(uFFTTexture, vec2(p.z * 0.0001, 0.)).r;
  p.xy -= path(p.z).xy;
  // p.xy = rot2D(0.05 * p.z) * p.xy;
  // p.xy = fold(p.xy, PI/6.);
  // p = mod(p, 3.) - 1.5;
  float tube = -(length( p.xy ) - 2.);
  acc = min( acc, tube );
  return acc;
}

float AO( float eps, vec3 p, vec3 n ) {
  return clamp( map( p + eps * n ) / eps, 0., 1.);
}

vec3 calcNormal( in vec3 p ) // for function map(p)
{
    const float eps = 0.001; // or some other value
    const vec2 k = vec2( 1., -1. );

    return normalize( k.xyy * map(p + k.xyy * eps) +
                      k.yyx * map(p + k.yyx * eps) +
                      k.yxy * map(p + k.yxy * eps) +
                      k.xxx * map(p + k.xxx * eps) );
}

vec3 normal( in vec3 p ) {
  //tetrahedron normal
  const float n_er=0.01;
  float v1=map(vec3(p.x+n_er,p.y-n_er,p.z-n_er));
  float v2=map(vec3(p.x-n_er,p.y-n_er,p.z+n_er));
  float v3=map(vec3(p.x-n_er,p.y+n_er,p.z-n_er));
  float v4=map(vec3(p.x+n_er,p.y+n_er,p.z+n_er));
  return normalize(vec3(v4+v1-v3-v2,v3+v4-v1-v2,v2+v4-v3-v1));
}

vec3 raymarch( in vec3 ro, in vec3 rd, in int maxIterations ) {
  const float minDistance = 0.;
  const float maxDistance = 100.;
  const float precis = 0.001;

  float dt = 0.;
  float d = minDistance;
  vec3 p = ro;

  for ( int i = 0; i < maxIterations; i++ ) {
    d = map( p );
    dt += d;

    if ( d < precis ) break;
    p += rd * d * 0.5;
  }

  if ( dt > maxDistance ) dt = -1.;
  return vec3(dt, d, p.z);
}

void main() {
  vec3 color = vec3(vUv, 0.0);

  vec2 uv = vUv * 2.0 - 1.0;
  uv.y /= uResolution.x / uResolution.y;

  float time = uTime * 10.;
  
  // RAYMARCHING
  vec3 ro = vec3( 0., 0., 25. );
  ro = path(time);
  vec3 tar = ro + vec3(0., 0., 5.);
  tar = path(time + 25.);
  mat3 camMat = calcLookAtMatrix( ro, tar, 0. );
  vec3 rd = normalize( camMat * vec3( uv, 1. ) );

  vec3 rm = raymarch( ro, rd, 100 );
  float dt = rm.x;
  float d = rm.y;

  vec3 p = ro + rd * dt;
  vec3 n = calcNormal( p );

  color = vec3(n);
  
  gl_FragColor = vec4(color, 1.0);
}
