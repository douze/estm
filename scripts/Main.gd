# Handle display & interaction of the main scene, used for the wfc algorithm
extends Spatial

var _mesh_to_print: int = -1
var _support_width: int = 5
var _support_height: int = 4
var _input: Array


func _ready():
	randomize()


# Return the coordinates of the gridmap cell under the cursor
func _get_gridmap_coordinates() -> Vector3:
	var mouse_position := get_viewport().get_mouse_position()
	var ray_from: Vector3 = $CameraPivot/Camera.project_ray_origin(mouse_position)
	var ray_to: Vector3 = ray_from + $CameraPivot/Camera.project_ray_normal(mouse_position) * 200
	var intersection := get_world().direct_space_state.intersect_ray(ray_from, ray_to)
	if not intersection: return Vector3.INF
	return $GridMap.world_to_map(intersection.position)


# Return the id of the mesh under the cursor
func _get_selected_mesh() -> int:
	var grid_coordinates := _get_gridmap_coordinates()
	if grid_coordinates == Vector3.INF or grid_coordinates.y == -1: return -1
	return $GridMap.get_cell_item(grid_coordinates.x, grid_coordinates.y, grid_coordinates.z)


# Handle input interaction
func _input(event: InputEvent):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var current_selected_mesh := _get_selected_mesh()
		if current_selected_mesh != -1:
			_mesh_to_print = current_selected_mesh
	
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		var grid_coordinates = _get_gridmap_coordinates()
		if grid_coordinates != Vector3.INF:
			$GridMap.set_cell_item(grid_coordinates.x, 0, grid_coordinates.z, _mesh_to_print)
	
	if Input.is_key_pressed(KEY_ENTER):
		_convert_to_input_array()


# Convert the scene to the input array, needed for wfc
func _convert_to_input_array() -> void:
	if _input.empty(): 
		for z in range(-_support_height, _support_height):
			var row := []
			for x in range(-_support_width, _support_width + 1):
				var mesh: int =  $GridMap.get_cell_item(x, 0, z)
				var letter: String
				if (mesh == 0): letter = 'C'
				if (mesh == 1): letter = 'L'
				if (mesh == 2): letter = 'W'
				row.append(letter)
			_input.append(row)
	_execute_wfc(_input)


# Execute the wfc algorithm
func _execute_wfc(input: Array) -> void:
	var matrix: Matrix = Matrix.new(input)
	if matrix.is_size_constant():
		var parsed_result := matrix.parse()
		var model: Model = Model.new(Vector2(_support_width*2+1, _support_height), parsed_result[1], parsed_result[0])
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


