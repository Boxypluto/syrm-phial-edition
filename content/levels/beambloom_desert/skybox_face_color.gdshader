shader_type spatial;
render_mode unshaded, shadows_disabled, cull_back;


uniform vec4 albedo : source_color;

void vertex() {
	MODELVIEW_MATRIX[3].xyz = vec3(0.0);
}

void fragment() {
	ALBEDO = albedo.rgb;
	DEPTH = 0.0;
}
