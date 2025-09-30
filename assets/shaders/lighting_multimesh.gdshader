shader_type spatial;

uniform sampler2D albedo: filter_nearest, repeat_enable;
uniform sampler2D normal_map: hint_normal, filter_nearest, repeat_enable;
uniform float normal_strength = 1.0;
uniform vec3 modulate: source_color = vec3(1.0);
uniform bool disable_light = false;
uniform float light_strength = 1.0;
uniform int image_count = 1;

void fragment() {
	float image_width = 1.0 / float(image_count);
	float offset = float(int(float(VIEW_INDEX)));
	vec2 uv = UV * vec2(image_width, 1) + vec2(image_width * offset, 1);
	vec4 albedo_color = texture(albedo, uv);
	NORMAL_MAP = texture(albedo, uv).rgb;
	
	NORMAL_MAP_DEPTH = normal_strength;
	ALBEDO = albedo_color.rgb * modulate;
	ALPHA = albedo_color.a;
}

float round_interval(float value, float interval) {
	return interval * round(value / interval);
}

vec3 round_interval(vec3 value, float interval) {
	return interval * round(value / interval);
}
float snap(float value, float threshold) {
	if (value > threshold) return 1.0;
	else return 0.0;
}
void light() {
	if(!disable_light) {
		vec3 surface_normal = normalize(NORMAL);
		vec3 light_normal = normalize(LIGHT);

		// Lambertian-Diffuise-style lighting rounded
		float lighting_soft = max(dot(surface_normal, light_normal), 0.0);
		float lighting = round_interval(lighting_soft, 0.2);

		DIFFUSE_LIGHT += lighting * ALBEDO * LIGHT_COLOR * ATTENUATION * light_strength;
	} else {
		DIFFUSE_LIGHT = ALBEDO;
	}
}