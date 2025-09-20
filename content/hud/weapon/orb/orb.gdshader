shader_type canvas_item;

uniform int bit_shift_scale = 0;
uniform int flash_state = 0;
uniform sampler2D noise: filter_nearest, repeat_enable;
uniform sampler2D fail_noise: filter_nearest, repeat_enable;
uniform float noise_scale = 1.0;

void fragment() {
	switch(flash_state) {
		case 0:
			bool x_compare = (int(FRAGCOORD.x) >> bit_shift_scale & 2) == 0;
			bool y_compare = (int(FRAGCOORD.y)  >> bit_shift_scale & 2) == 0;
			if((x_compare || y_compare) && !(x_compare && y_compare)) {
				COLOR.a = 0.0;
			}
			break;
		case 1:
			COLOR.rgb = vec3(1.0);
			break;
		case 2:
			COLOR.rgb -= 0.5;
			COLOR.r += texture(noise, UV * noise_scale + TIME).r;
			COLOR.g += texture(noise, UV * noise_scale / 2.0  + TIME * vec2(0.5, -0.2)).g;
			COLOR.b += texture(noise, UV * noise_scale / 4.0 + TIME * vec2(-0.6, 0.8)).b;
			break;
		case -1:
			COLOR.rgb = vec3(1.0, 0.0, 0.0);
			break;
		case -2:
			COLOR.rgb -= 0.5;
			COLOR.r += texture(fail_noise, UV * noise_scale + TIME).r;
			COLOR.g += texture(fail_noise, UV * noise_scale / 2.0  + TIME * vec2(0.5, -0.2)).g;
			COLOR.b += texture(fail_noise, UV * noise_scale / 4.0 + TIME * vec2(-0.6, 0.8)).b;
			COLOR.gb *= 0.4;
			break;
	}
}