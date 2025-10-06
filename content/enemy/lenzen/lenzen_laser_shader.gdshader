shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D albedo_texture: filter_nearest, source_color, repeat_enable;

void fragment() {
	vec4 sample = texture(albedo_texture, UV * vec2(1.0, 200.0) + vec2(0, TIME * 20.0));
	ALBEDO = sample.rgb;
	ALPHA = floor(sample.a);
}