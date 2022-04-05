// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

uniform float cx;
uniform float cy;
uniform float window_w;
uniform float window_h;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

//macros for complex number operations ripped straight from their definition
#define product(a, b) vec2(a.x*b.x-a.y*b.y, a.x*b.y+a.y*b.x)
#define conjugate(a) vec2(a.x,-a.y)
#define divide(a, b) vec2(((a.x*b.x+a.y*b.y)/(b.x*b.x+b.y*b.y)),((a.y*b.x-a.x*b.y)/(b.x*b.x+b.y*b.y)))

vec2 julia_func(vec2 in_z, vec2 in_c){
	return product(product(in_z,in_z),in_z) + in_c;
}

float radius(vec2 inpu){ //input is reserved so inpu will do
		return sqrt(inpu.x * inpu.x + inpu.y * inpu.y);
}

void main() {
//vec2's are complex numbers. x = a and y = b in a + bi
vec2 z = vec2(vertTexCoord.x,vertTexCoord.y);
for(int i = 0; i < 20; i++){
	z = julia_func(z,vec2(cx,cy));
}

//seems like we only need to modify this vec4
  vec4 diffuse_color = vec4(1.0, 0, 0.0, 1.0);
if(radius(z) < 4)
	diffuse_color = vec4(1.0,1.0,1.0,1.0);
//if(radius(z) < 4.0)
	//diffuse_color = vec4(1.0,1.0,1.0,1.0);

  float diffuse = clamp(dot(vertNormal, vertLightDir),0.0,1.0);
  gl_FragColor = vec4(diffuse * diffuse_color.rgb, 1.0);

}
