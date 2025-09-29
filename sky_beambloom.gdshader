shader_type sky;

uniform vec3 main_color: source_color;

void sky() {
	COLOR = main_color;
}
