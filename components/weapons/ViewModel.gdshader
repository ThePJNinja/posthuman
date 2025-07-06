shader_type spatial;

uniform float fov = 77;

void vertex() {
	// Called for every vertex the material is visible on.
	//UV = UV * uv1_scale.xy + uv1_offset.xy;

	float scale = 1.0 / tan(fov * 0.5 * PI / 180.0);
	PROJECTION_MATRIX[0][0] = scale / (VIEWPORT_SIZE.x / VIEWPORT_SIZE.y);
	PROJECTION_MATRIX[1][1] = -scale;

	//POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX.xyz, 1.0);
	//POSITION.z = mix(POSITION.z, 0.0, 0.99);
}

void fragment() {
	// Called for every pixel the material is visible on.
	DEPTH = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
