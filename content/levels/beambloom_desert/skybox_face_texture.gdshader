shader_type spatial;
render_mode unshaded, shadows_disabled, cull_back;


uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_nearest, repeat_enable;

void vertex() {
	MODELVIEW_MATRIX[3].xyz = vec3(0.0);
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	DEPTH = 0.0;
}
