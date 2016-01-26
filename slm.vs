precision highp float;

attribute vec3 position;

//uniform float lens_xoffset;
//uniform float lens_yoffset;
//uniform float array_xoffset;

//uniform float vlens_radius;
//uniform float hlens_radius;
//uniform float array_radius;

varying vec2 lensDistance;
varying vec2 arrayDistance;

varying vec4 heightOffset;

#define pixel_pitch 0.008 //in mm/pixel
#define xres 1920.0
#define yres 1080.0

float lens_xoffset = 0.0;
float lens_yoffset = 0.0;
float array_xoffset = 0.0;

float vlens_radius = 500.0;
float hlens_radius = 100.0;
float array_radius = 50.0;

void main(void) {
	vec2 sdim = vec2(xres, yres)*pixel_pitch*0.5;
	lensDistance = position.xy*sdim - vec2(lens_xoffset, lens_yoffset);
	arrayDistance = position.xy*sdim - vec2(lens_xoffset+array_xoffset, lens_yoffset);
	gl_Position = vec4(position, 1.0);

	//now calculate height offsets for inverted lenses
	if(vlens_radius < 0.0){
		heightOffset.x = abs( (sdim.x*sdim.x)/(2.0*vlens_radius));
	}
	if (hlens_radius < 0.0){
		heightOffset.y = abs( (sdim.x*sdim.x)/(2.0*hlens_radius));
	}
	if (array_radius < 0.0){
		heightOffset.z = abs( (sdim.x*sdim.x)/(2.0*array_radius));
	}
	heightOffset.w = heightOffset.x+heightOffset.y+heightOffset.z;
}
