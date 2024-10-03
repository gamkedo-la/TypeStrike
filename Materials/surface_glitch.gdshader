shader_type spatial;

uniform float offset_scale = 0.f;
uniform float offset_frequency = 10.f;

void vertex() {
	float costime = cos(TIME * offset_frequency);
	float sintime = sin(TIME * offset_frequency);
	VERTEX.xyz += NORMAL.xyz * abs(costime * sintime) * offset_scale;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
