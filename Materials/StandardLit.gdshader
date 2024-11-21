shader_type spatial;
render_mode blend_add, cull_disabled, depth_draw_opaque;

group_uniforms Albedo;
uniform sampler2D color_texture;
uniform vec4 base_color : source_color;
uniform vec2 uv_scroll;
uniform float uv_scroll_step;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float time_step = TIME;
	vec2 uv_offset = time_step * uv_scroll;
	// "stepped" animation commented out as I preferred smooth movement
	// here's the working original awesome version:
	// float fract_offset = 0f;//round(fract(time_step) * 10.f) * uv_scroll_step;
	// vec2 uv_offset = (floor(time_step) + fract_offset) * uv_scroll;
	vec4 albedo_texture = texture(color_texture, UV + uv_offset);
	vec4 color = albedo_texture * base_color;
	
	ALBEDO = color.rgb;
	//ALPHA = max(color.r, max(color.g, color.b));
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
