shader_type particles;

uniform float scale = 0.1;
uniform float width = 4.0;
uniform float random_position_scale = 100.0;

float rand_from_seed(uint seed) {
	int k;
	int s = int(seed);
	if (s == 0) {
		s = 305420679;
	}
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0) {
		s += 2147483647;
	}
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

void start() {
	TRANSFORM[3].xyz = vec3(rand_from_seed(RANDOM_SEED + NUMBER + uint(1.0 + TIME * 100.0)), rand_from_seed(RANDOM_SEED + NUMBER + uint(2.0 + TIME * 100.0)), rand_from_seed(RANDOM_SEED + NUMBER + uint(3.0 + TIME * 100.0))) * random_position_scale;

	TRANSFORM *= EMISSION_TRANSFORM;

}

void process() {
	TRANSFORM[3].xyz += vec3(0.1 * width,  0.0, 0.0);
	TRANSFORM[3].y += sin(TRANSFORM[3].x) / scale;
}
