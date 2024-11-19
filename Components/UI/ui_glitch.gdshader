shader_type canvas_item;

uniform vec3 font_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float speed : hint_range(0.0, 5.0, 0.1);
uniform float amount : hint_range(0.0, 1.0, 0.1);
uniform float shake_power = 0.03;
uniform float shake_block_size = 30.5;
uniform float shake_color_rate : hint_range( 0.0, 1.0 ) = 0.01;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 distortion(vec2 p, float t) {
	vec2 freq = vec2(10.0, 30.0);
	vec2 amplitude = vec2(0.02, 0.05);
	vec2 offset = vec2(-0.1, 0.1);
	vec2 distortion = 0.5 * sin(freq * p * t + offset);
	distortion *= amplitude * (1.0 - smoothstep(0.0, 1.0, p.y));
	distortion *= 1.0 - pow(p.y, 3.0);
	distortion *= step(p.y, 1.0) * step(0.0, p.y);
	return distortion;
}

float random( float seed )
{
	return fract( 543.2543 * sin( dot( vec2( seed, seed ), vec2( 3525.46, -54.3415 ) ) ) );
}

void fragment() {
	float t = TIME * speed;
	vec2 distortionAmount = distortion(UV, t);
	vec2 offset = distortionAmount * amount;
	vec4 color = textureLod(screen_texture, UV + offset, 0);
	//COLOR = vec4(1, 0, 0, COLOR.a);
	//COLOR = color;
	// Called for every pixel the material is visible on.


	float enable_shift = float(
		random( trunc( TIME * speed ) )
	<	amount
	);

	vec2 fixed_uv = SCREEN_UV;
	fixed_uv.x += (
		random(
			( trunc( SCREEN_UV.y * shake_block_size ) / shake_block_size )
		+	TIME
		) - 0.5
	) * shake_power * enable_shift;

	vec4 pixel_color = textureLod( screen_texture, fixed_uv, 0.0 );
	pixel_color.r = mix(
		pixel_color.r
	,	textureLod( screen_texture, fixed_uv + vec2( shake_color_rate, 0.0 ), 0.0 ).r
	,	enable_shift
	);
	pixel_color.b = mix(
		pixel_color.b
	,	textureLod( screen_texture, fixed_uv + vec2( -shake_color_rate, 0.0 ), 0.0 ).b
	,	enable_shift
	);
	COLOR = pixel_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
