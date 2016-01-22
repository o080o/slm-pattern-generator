precision highp float;

uniform float vlens_radius;
uniform float hlens_radius;
uniform float array_radius;
uniform float array_pitch;

uniform float wavelength;

varying vec2 distance; //distance in mm from the center of the lens!



void main(void) {
	float height = sin(abs(distance.x) / hlens_radius);
	gl_FragColor = vec4( height, height, 1.0, 1.0);
}
