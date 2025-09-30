shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D albedo: filter_nearest;
uniform vec3 location;

void fragment() {
	vec4 color = texture(albedo, UV);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}