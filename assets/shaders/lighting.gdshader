shader_type spatial;
render_mode diffuse_toon, specular_toon;

uniform sampler2D albedo;
uniform vec2 texture_scale = vec2(1.0);

void fragment() {
	ALBEDO = texture(albedo, UV * texture_scale).rgb;
}

float snap(float value, float threshold) {
	if (value > threshold) return 1.0;
	else return 0.0;
}

void light() {
	vec3 surface_normal = normalize(NORMAL);
	vec3 light_normal = normalize(LIGHT);

	// Lambertian-Diffuise-style lighting rounded
	float lighting_soft = max(dot(surface_normal, light_normal), 0.0);
	float lighting = round(lighting_soft);

	DIFFUSE_LIGHT += lighting * ALBEDO * LIGHT_COLOR * (snap(ATTENUATION, 0.0) / 0.5) / 10.0;
}