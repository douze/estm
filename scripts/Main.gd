extends Spatial

func _ready():
	randomize()
	#_execute_wfc()

var selected_mesh: int = -1

func get_gridmap_coordinates() -> Vector3:
	var mouse_position := get_viewport().get_mouse_position()
	var ray_from: Vector3 = $CameraPivot/Camera.project_ray_origin(mouse_position)
	var ray_to: Vector3 = ray_from + $CameraPivot/Camera.project_ray_normal(mouse_position) * 200
	var intersection := get_world().direct_space_state.intersect_ray(ray_from, ray_to)
	if not intersection: return Vector3.INF
	return $GridMap.world_to_map(intersection.position)


func get_selected_mesh() -> int:
	var grid_coordinates = get_gridmap_coordinates()
	if grid_coordinates == Vector3.INF: return -1
	return $GridMap.get_cell_item(grid_coordinates.x, grid_coordinates.y, grid_coordinates.z)


func _input(event: InputEvent):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		selected_mesh = get_selected_mesh()
	
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		var grid_coordinates = get_gridmap_coordinates()
		if grid_coordinates != Vector3.INF:
			$GridMap.set_cell_item(grid_coordinates.x, 0, grid_coordinates.z, selected_mesh)


func _execute_wfc() -> void:
	var input: Array = [
		['L','L','L','L'],
		['L','L','L','L'],
		['L','L','L','L'],
		['L','C','C','L'],
		['C','S','S','C'],
		['S','S','S','S'],
		['S','S','S','S']
	]
	var matrix: Matrix = Matrix.new(input)
	if matrix.is_size_constant():
		var parsed_result := matrix.parse()
		var model: Model = Model.new(Vector2(4, 7), parsed_result[1], parsed_result[0])
		model.run()
		
		var mesh_library = $GridMap.mesh_library
		var coast_mesh = mesh_library.find_item_by_name("Coast")
		var land_mesh = mesh_library.find_item_by_name("Land")
		var water_mesh = mesh_library.find_item_by_name("Water")
		
		var center := Vector2(model._wavefunction._width / 2, model._wavefunction._height / 2)
		for y in model._wavefunction._height:
			for x in model._wavefunction._width:
				var tile = model._wavefunction.get_coefficients(Vector2(x,y))[0]
				if tile == 'C':
					$GridMap.set_cell_item(x-center.x, 0, y-center.y, coast_mesh)
				if tile == 'L':
					$GridMap.set_cell_item(x-center.x, 0, y-center.y, land_mesh)
				if tile == 'S':
					$GridMap.set_cell_item(x-center.x, 0, y-center.y, water_mesh)
		

