shader_type spatial;

uniform float offset_scale = 0.f;
uniform float offset_frequency = 10.f;

uniform sampler2D Albedo;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123); 
}

float noise(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    vec2 a = vec2(1.0, 0.0);
    return mix(mix(hash(p + a.yy), hash(p + a.xy), f.x), mix(hash(p + a.yx), hash(p + a.xx), f.x), f.y);
}

void vertex() {
	vec2 panner = UV + vec2(TIME * offset_frequency);
	VERTEX.xyz += NORMAL.xyz * noise(panner) * offset_scale;
}

void fragment() {
	ALBEDO = texture(Albedo, UV, 0).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
