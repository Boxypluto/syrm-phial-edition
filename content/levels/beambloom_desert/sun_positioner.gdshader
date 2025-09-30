shader_type spatial;
render_mode unshaded, world_vertex_coords;

uniform sampler2D color_texture: filter_nearest;
uniform vec4 modulate: source_color = vec4(1.0);
uniform float sun_distance;

void fragment() {
	vec4 color = texture(color_texture, UV) * modulate;
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
