# Handle display & interaction of the main scene, used for the wfc algorithm
extends Spatial

var _mesh_to_print: int = -1
var _pattern_size: int = 5
var _pattern_origin: Vector2 = Vector2(-1, -10)
var _support_width: int = 14
var _support_height: int = 8
var _support_origin: Vector2 = Vector2(-7, -4)


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
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()



# Convert the scene to the input array, needed for wfc
func _convert_to_input_array() -> void:
	var input := []
	for y in range(_pattern_origin.y, _pattern_origin.y + _pattern_size):
		var row := []
		for x in range(_pattern_origin.x, _pattern_origin.x + _pattern_size):
			row.append(str($GridMap.get_cell_item(x, 0, y)))
		input.append(row)
	_execute_wfc(input)


# Execute the wfc algorithm
func _execute_wfc(input: Array) -> void:
	var matrix: Matrix = Matrix.new(input)
	if matrix.is_size_constant():
		var parsed_result := matrix.parse()
		var model: Model = Model.new(Vector2(_support_width, _support_height), parsed_result[1], parsed_result[0])
		model.run()
		
		if not model.wavefunction.is_fully_collapsed(): return
				
		for y in _support_height:
			for x in _support_width:
				var tile: String = model.wavefunction.get_coefficients(Vector2(x,y))[0]
				var position := Vector2(x + _support_origin.x, y + _support_origin.y)
				$GridMap.set_cell_item(position.x, 0, position.y, int(tile))

