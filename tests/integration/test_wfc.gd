extends 'res://addons/gut/test.gd'

var Matrix = load('res://scripts/matrix.gd')
var Model = load('res://scripts/model.gd')
var Wavefunction = load('res://scripts/wavefunction.gd')


func test_wfc() -> void:
	var input: Array = [
		['L','L'],
		['C','L'],
		['S','C'],
		['S','S']
	]
	var matrix: Matrix = Matrix.new(input, 2, 4)
	if matrix.is_size_constant():
		var parsed_result := matrix.parse()
		var model: Model = Model.new(Vector2(4, 7), parsed_result[1], parsed_result[0])
		model.run()
		print(Matrix.new(model._wavefunction._coefficients, 4, 7))
