precision highp float;

uniform float vlens_radius;
uniform float hlens_radius;
uniform float array_radius;
uniform float array_pitch;

uniform float wavelength;

varying vec2 distance; //distance in mm from the center of the lens!



void main(void) {
	gl_FragColor = vec4( distance, 0.0, 1.0);
}
