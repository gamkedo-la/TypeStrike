shader_type canvas_item;
uniform float u_amp_flutter: hint_range(0, 100) = 10.0;
uniform float u_angle_flutter: hint_range(-180, 180) = 30.0;
uniform float u_speed_flutter: hint_range(0.1, 10) = 1.0;
uniform float u_amp_wave: hint_range(0, 100) = 10.0;
uniform float u_angle_wave: hint_range(-180, 180) = -30.0;
uniform float u_speed_wave: hint_range(0, 10) = 2.0;
uniform float u_len_wave: hint_range(10, 1000) = 100.0;
uniform float u_shape_wave: hint_range(1, 10) = 3;
uniform float u_width_wave: hint_range(0.1, 4) = 1;
uniform float u_x_light: hint_range(-1, 4) = 0.2;
uniform float u_shape_light: hint_range(0.5, 4) = 2;
uniform float u_width_light: hint_range(0.1, 2) = 1;


uniform float u_speed: hint_range(0.0, 5.0, 0.1);
uniform float u_amount: hint_range(0.0, 30.0, 0.1);

vec2 rotate(vec2 v, float angle) {
	mat2 rotation_matrix = mat2(
			vec2(cos(angle / 180.0 * PI), -sin(angle / 180.0 * PI)),
			vec2(sin(angle / 180.0 * PI), cos(angle / 180.0 * PI)));
	return v * rotation_matrix;
}

float lorentzian(float x, float x0, float w, float shp) {
	// modified lorentzian peak function with half-width w and exponent shp
	// around center of x0. Normalized to be 1 at x0.
	return pow(w, 2) / (pow(abs(x - x0), shp) + pow(w, 2));
}

float lorentzian_periodic(float x, float x0, float w, float shp, float per) {
	return lorentzian(mod(x - per/ 2.0 - x0, per), per / 2.0, w, shp);
}

vec2 distortion(vec2 p, float t) {
	vec2 frequency = vec2(10.0, 30.0);
	vec2 amplitude = vec2(0.02, 0.05);
	vec2 speed = vec2(0.1, 0.2);
	vec2 offset = vec2(-0.1, 0.1);
	vec2 distortion = 0.5 * sin(frequency * p * t + offset);
	distortion *= amplitude * (1.0 - smoothstep(0.0, 1.0, p.y));
	distortion *= 1.0 - pow(p.y, 3.0);
	distortion *= step(p.y, 1.0) * step(0.0, p.y);
	return distortion;
}

varying float enable_shift;
// Glitch intensity
uniform float shake_power = 0.5;

// Probability
uniform float shake_rate : hint_range(0.0, 1.0) = 0.5;

uniform float shake_speed = 5.0;

// Hard to describe, change it and monitor result
uniform float shake_block_size = 30.5;

uniform float shake_color_rate : hint_range(0.0, 1.0) = 0.5;

float random(float seed) {
    return fract(sin(seed * 12345.678) * 43758.5453);
}

void vertex() {
	//float x = mod(VERTEX.x / u_len_wave, 1.0) * 4.0 - 2.0;
	//float x0 = TIME * u_speed_wave;
	//float amp_wave = u_amp_wave * lorentzian_periodic(x, x0, u_width_wave, u_shape_wave, 4);
	//vec2 wave = rotate(vec2(amp_wave, 0), u_angle_wave);
	//float amp_flutter = u_amp_flutter * sin(u_speed_flutter * TIME);
	//vec2 flutter = rotate(vec2(amp_flutter, 0), u_angle_flutter);
	//VERTEX = VERTEX + flutter + wave;
	
	//float t = TIME * u_speed;
	//vec2 distortion_amount = distortion(VERTEX, t);
	//vec2 offset = distortion_amount * u_amount;
	//VERTEX = VERTEX + offset;
	
	float adjusted_time = mod(TIME, 5.0);
	//float adjusted_time = TIME * u_speed;

    enable_shift = float(random(trunc(adjusted_time * shake_speed)) < shake_rate);
	
	//SCREEN_MATRIX
	//float ftime = fract(adjusted_time);
	//enable_shift = step(UV.y, ftime) - step(UV.y, ftime - 0.01);
 
    float offset_x = (random((trunc(UV.y + shake_block_size) / shake_block_size) + adjusted_time) - 0.5) * shake_power * enable_shift;
	UV.x += offset_x;
    //VERTEX.x += offset_x;
}


void fragment() {
	float adjusted_time = TIME * u_speed;
	float ftime = fract(adjusted_time);
	//enable_shift = step(UV.y, ftime) - step(UV.y, ftime - 0.01);
	COLOR = vec4(0, enable_shift, 0, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
