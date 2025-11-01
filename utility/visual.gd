class_name Visual

static func ray(screen_position: Vector2, spawn_depth: float, ray_result: RayResult, width: float, shot_material: Material, destory_after_time: float = 2.0):
	var player: Player = Game.PLAYER
	
	var start: Vector3 = player.camera.project_position(screen_position, spawn_depth)
	var end: Vector3 = ray_result.end_position()
	var local_end: Vector3 = end - start
	var right: Vector3 = start.direction_to(end).rotated(Vector3.UP, deg_to_rad(90))
	var left: Vector3 = -right
	var up: Vector3 = start.direction_to(end).rotated(right, deg_to_rad(90))
	var down: Vector3 = -up
	var h_mesh: ArrayMesh = ArrayMesh.new()
	var v_mesh: ArrayMesh = ArrayMesh.new()
	var h_arrays: Array = []
	var v_arrays: Array = []
	h_arrays.resize(Mesh.ARRAY_MAX)
	v_arrays.resize(Mesh.ARRAY_MAX)
	h_arrays[Mesh.ARRAY_VERTEX] = PackedVector3Array([
		left * width / 2.0,
		right * width / 2.0,
		local_end + left * width / 2.0,
		local_end + left * width / 2.0,
		local_end + right * width / 2.0,
		right * width / 2.0,
	])
	v_arrays[Mesh.ARRAY_VERTEX] = PackedVector3Array([
		up * width / 2.0,
		down * width / 2.0,
		local_end + up * width / 2.0,
		local_end + up * width / 2.0,
		local_end + down * width / 2.0,
		down * width / 2.0,
	])
	h_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, h_arrays)
	v_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, v_arrays)
	var h_mesh_instance: MeshInstance3D = MeshInstance3D.new()
	var v_mesh_instance: MeshInstance3D = MeshInstance3D.new()
	h_mesh_instance.mesh = h_mesh
	v_mesh_instance.mesh = v_mesh
	h_mesh_instance.material_override = shot_material
	v_mesh_instance.material_override = shot_material
	Game.add_spawned(h_mesh_instance)
	Game.add_spawned(v_mesh_instance)
	h_mesh_instance.global_position = start
	v_mesh_instance.global_position = start
	Game.GAME.get_tree().create_timer(destory_after_time).timeout.connect(func():
		if h_mesh_instance != null: h_mesh_instance.queue_free()
		if v_mesh_instance != null: v_mesh_instance.queue_free()
	)
