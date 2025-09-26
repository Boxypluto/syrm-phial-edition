shader_type spatial;
render_mode diffuse_toon, specular_toon;

uniform sampler2D albedo;
uniform sampler2D normal_map;
uniform vec2 texture_size;

varying vec3 uv1_triplanar_pos;
varying vec3 uv2_triplanar_pos;

varying vec3 uv1_power_normal;
varying vec3 uv2_power_normal;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float uv1_blend_sharpness : hint_range(0.0, 150.0, 0.001);
uniform float uv2_blend_sharpness : hint_range(0.0, 150.0, 0.001);

void vertex() {
	vec3 normal = NORMAL;

	TANGENT = vec3(0.0, 0.0, -1.0) * abs(normal.x);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.y);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.z);
	TANGENT = normalize(TANGENT);

	BINORMAL = vec3(0.0, 1.0, 0.0) * abs(normal.x);
	BINORMAL += vec3(0.0, 0.0, -1.0) * abs(normal.y);
	BINORMAL += vec3(0.0, 1.0, 0.0) * abs(normal.z);
	BINORMAL = normalize(BINORMAL);

	// UV1 Triplanar: Enabled
	uv1_power_normal = pow(abs(NORMAL), vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_power_normal /= dot(uv1_power_normal, vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0);

	// UV2 Triplanar: Enabled
	uv2_power_normal = pow(abs(NORMAL), vec3(uv2_blend_sharpness));
	uv2_triplanar_pos = VERTEX * uv2_scale + uv2_offset;
	uv2_power_normal /= dot(uv2_power_normal, vec3(1.0));
	uv2_triplanar_pos *= vec3(1.0, -1.0, 1.0);
}

float snap(float value, float threshold) {
	if (value > threshold) return 1.0;
	else return 0.0;
}

void fragment() {
	vec4 albedo_color = texture(albedo, UV * texture_size);
	NORMAL_MAP = texture(normal_map, UV * texture_size).rgb;
	NORMAL_MAP_DEPTH = 1.0;
	ALBEDO = albedo_color.rgb;
}

void light() {
	vec3 surface_normal = normalize(NORMAL);
	vec3 light_normal = normalize(LIGHT);

	// Lambertian-Diffuise-style lighting rounded
	float lighting_soft = max(dot(surface_normal, light_normal), 0.0);
	float lighting = round(lighting_soft);

	DIFFUSE_LIGHT += lighting * ALBEDO * LIGHT_COLOR * (snap(ATTENUATION, 0.0) / 0.5) / 10.0;
}