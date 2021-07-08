extends Spatial

func _ready():
	randomize()
	_execute_wfc()


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
		

