shader_type canvas_item;

uniform sampler2D noise_1: repeat_enable;



void fragment() {
	
	vec2 uv = UV + vec2(sin(TIME), sin(TIME)) / 52.0;
	
	float alpha = texture(TEXTURE, vec2(0.0)).a;
	
	COLOR.rgb = texture(TEXTURE, uv).rgb;
	
	float offset = sin(TIME * 10.0);
	float wobble_size = 0.3;
	
	COLOR.a += texture(TEXTURE, uv + 0.02 * offset * wobble_size).a / 6.0;
	COLOR.a += texture(TEXTURE, uv - 0.02 * offset * wobble_size).a / 6.0;
	COLOR.a += texture(TEXTURE, uv + vec2(0.0, 0.002)  * offset * wobble_size).a / 6.0;
	COLOR.a = log(COLOR.a);
	
	COLOR.rgb = vec3(0.0);
	COLOR.r = texture(noise_1, uv + TIME / 5.0 * vec2(0.4, 0)).r / 2.0;
	COLOR.rg += texture(noise_1, uv * 2.0 - TIME / 3.0).rg / 7.0;
}