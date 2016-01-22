precision highp float;

attribute vec3 position;

uniform float lens_xoffset;
uniform float lens_yoffset;
uniform float array_xoffset;

varying vec2 lensDistance;
varying vec2 arrayDistance;

#define pixel_pitch 0.008 //in mm/pixel
#define xres 1920.0
#define yres 1080.0
#define swidth xres*pixel_pitch
#define sheight yres*pixel_pitch

void main(void) {
	lensDistance = vec2(position.x*swidth, position.y*sheight) - vec2(lens_xoffset, lens_yoffset);
	arrayDistance = vec2(position.x*swidth, position.y*sheight) - vec2(lens_xoffset+array_xoffset, lens_yoffset);
	gl_Position = vec4(position, 1.0);
}
