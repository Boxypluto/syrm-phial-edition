shader_type spatial;
render_mode unshaded, depth_draw_opaque, cull_front, depth_test_default;
stencil_mode write, 1;

uniform vec4 modulate: source_color = vec4(1.0);

void fragment() {
	ALBEDO = modulate.rgb;
}