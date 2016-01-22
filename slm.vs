precision highp float;

attribute vec3 position;

varying vec2 distance;

#define pixel_pitch 8.0
#define xres 1920.0
#define yres 1080.0
#define swidth xres*pixel_pitch
#define sheight yres*pixel_pitch

void main(void) {
	distance = vec2(position.x*swidth, position.y*sheight);
	gl_Position = vec4(position, 1.0);
}
