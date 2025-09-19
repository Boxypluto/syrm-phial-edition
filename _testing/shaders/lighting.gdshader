shader_type spatial;
render_mode diffuse_toon, specular_toon; 

void vertex() {
	// Called for every vertex the material is visible on.
}
 
void light() {
	DIFFUSE_LIGHT += round(dot(NORMAL, LIGHT)) * ALBEDO;
}