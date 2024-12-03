shader_type sky;


uniform sampler2D color_texture : hint_default_black;

void sky() {
	vec4 base_color = texture(color_texture, SKY_COORDS);
	COLOR = base_color.rgb;
}
