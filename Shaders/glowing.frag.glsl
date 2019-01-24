#version 450

uniform float iTime;
uniform vec2 iResolution;
out vec4 fragColor;

#define HASHSCALE1 .1031
float hash12(vec2 p)
{
	vec3 p3  = fract(vec3(p.xyx) * HASHSCALE1);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

float circle (vec2 p, float d)
{
    float f = length(p)-d;
    return f;
}

const vec2 add = vec2(1.0,0.0);

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(1.5-f)*2.0;
    
    float res = mix(mix( hash12(p), hash12(p + add.xy),f.x),
                    mix( hash12(p + add.yx), hash12(p + add.xx),f.x),f.y);
    return res;
}

const mat2 m = mat2( 0.80,  0.90, -0.90,  0.80 )*2.7;

float fbm4( vec2 p )
{
    float f = 0.0;
    f += 0.5000*noise( p ); p = m*p;
    f += 0.2500*noise( p ); p = m*p;
    f += 0.1250*noise( p ); p = m*p;
    f += 0.0625*noise( p );
    return f/0.9375;
}

float fbm6( vec2 p )
{
    float f = 0.0;
    f += 0.500000*(0.5+0.5*noise( p )); p = m*p;
    f += 0.250000*(0.5+0.5*noise( p )); p = m*p;
    f += 0.125000*(0.5+0.5*noise( p )); p = m*p;
    f += 0.062500*(0.5+0.5*noise( p )); p = m*p;
    f += 0.031250*(0.5+0.5*noise( p )); p = m*p;
    f += 0.015625*(0.5+0.5*noise( p ));
    return f/0.96875;
}

// Thanks to iq for writing this warp function, altering this saved me loads of time and experimentation...
// https://www.shadertoy.com/view/lsl3RH
vec3 lava(in vec2 q, in float d)
{
    q*=2.0;
    float ql = length( q );
    q.x += 0.05*sin(0.37*iTime+ql*4.7);
    q.y += 0.05*sin(0.33*iTime+ql*4.7);
    q *= 0.7;

	vec2 o = vec2(0.0);
    o.x = 0.5 + 0.5*fbm6(vec2(2.0*q));
    o.y = 0.5 + 0.5*fbm6(vec2(2.0*q));

	float ol = length( o );
    o.x += 0.02*sin(0.12*iTime*4.+ol)/ol;
    o.y += 0.02*sin(0.14*iTime*4.+ol)/ol;

    vec2 n;
    n.x = fbm6( vec2(7.0*o+vec2(19.2)));
    n.y = fbm6( vec2(7.0*o+vec2(15.7)));

    vec2 p = 4.0*q + 4.0*n;

    float f = 0.5 + .5 * fbm4( p );

    f = mix( f, f*f*f*3.5, f*abs(n.x) );

    float g = 0.5 + 0.5*sin(4.0*p.x)*sin(4.0*p.y);
    f *= 1.0-0.5*pow( g, 8.0 );

	//vec4 on = vec4( o, n );
	
    vec3 col = mix(vec3(f, f, 0), vec3(1.0-f*.3), smoothstep(-.01 , -.4, d));
    col += mix(vec3(0), vec3(pow(f, 5.0))*.4, smoothstep(-.01 , -.5, d));
    col =  mix(col, vec3(1,1,0), n.x*.5);
    col -= vec3(.0,1.,1.) * dot(o,o)*(d+.5);
    
    return col;
}

uniform float iGlow;
void main() {
    vec3 col = vec3(0);
    
    vec2 xy = gl_FragCoord.xy/iResolution;
    vec2 crd = (xy)*4.-2.;
    float c = 0.0;
    xy.x  *= iResolution.x/iResolution.y;
    crd.x *= iResolution.x/iResolution.y;
    
    float d = circle(crd, .85);
    float spread = iGlow; 	//radius of glow
    col = mix(col, vec3(.45, .3, .2), smoothstep(1. , 0., d));
    col = mix(col, vec3(.0, .6, 1.0), smoothstep(0.12 , .001, (1. / spread)*d)*.5);
    col = mix(vec3(.1,0.2,.1), col, smoothstep(0.0, 0.001, d+noise(crd*100.)*.005));
    col = mix(col, lava(crd, d), smoothstep(-.01 , -.015, d));

    fragColor = vec4(col, 1.0);
}
