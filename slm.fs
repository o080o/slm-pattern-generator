precision highp float;
precision highp int;

uniform float vlens_radius;
uniform float hlens_radius;
uniform float array_radius;
uniform float array_pitch;

uniform float wavelength;

varying vec2 lensDistance; //distance in micrometers from the center of the lens! (includes lens offset)
varying vec2 arrayDistance; //distance in micrometers from the center of the (array) lens! (includes lens+array offset)



void main(void) {
	float dlens = (lensDistance.x*lensDistance.x)/(2.0*hlens_radius);
	float dlens_vert = (lensDistance.y*lensDistance.y)/(2.0*vlens_radius);

	//float positiveX = arrayDistance.x + ((int((sxm/2)/pitch)+1)*pitch;
	//float arrayX = (positiveX + (array_pitch/2.0)) % array_pitch) - (array_pitch/2.0);

	float nPitch = floor((abs(arrayDistance.x)/array_pitch)+0.5); //calculate the number of lens waves this pixel is offset by
	float arrayDistanceX = abs(arrayDistance.x) - (float(nPitch) * array_pitch); //offset the distance so that this lens segment is situated about the origin (note the abs() does not change anything)
	float darray = (arrayDistanceX*arrayDistanceX) / (2.0*array_radius);

	float height = mod(darray + dlens, wavelength) / wavelength;
	//height = darray + dlens + dlens_vert;


	gl_FragColor = vec4(1.0-height, 1.0-height, 1.0-height, 1.0);
}


