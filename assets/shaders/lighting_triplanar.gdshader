shader_type spatial;
render_mode diffuse_toon, specular_toon; 

uniform sampler2D albedo;

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
	// UV1 Triplanar
	uv1_power_normal = pow(abs(NORMAL), vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_power_normal /= dot(uv1_power_normal, vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0);

	// UV2 Triplanar
	uv2_power_normal = pow(abs(NORMAL), vec3(uv2_blend_sharpness));
	uv2_triplanar_pos = VERTEX * uv2_scale + uv2_offset;
	uv2_power_normal /= dot(uv2_power_normal, vec3(1.0));
	uv2_triplanar_pos *= vec3(1.0, -1.0, 1.0);
}

vec4 triplanar_texture(sampler2D p_sampler, vec3 p_weights, vec3 p_triplanar_pos) {
	vec4 samp = vec4(0.0);
	samp += texture(p_sampler, p_triplanar_pos.xy) * p_weights.z;
	samp += texture(p_sampler, p_triplanar_pos.xz) * p_weights.y;
	samp += texture(p_sampler, p_triplanar_pos.zy * vec2(-1.0, 1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	vec4 albedo_color = triplanar_texture(albedo, uv1_power_normal, uv1_triplanar_pos);
	ALBEDO = albedo_color.rgb;
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