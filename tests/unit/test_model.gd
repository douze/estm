extends 'res://addons/gut/test.gd'

var Model = load('res://scripts/model.gd')

var size := Vector2(2, 4)
var compatibilities := [
		['L', Vector2(1, 0), 'L'],
		['L', Vector2(-1, 0), 'L'],
		['L', Vector2(0, 1), 'L'],
		['L', Vector2(0, -1), 'L'],
		['L', Vector2(0, 1), 'C'],
		['L', Vector2(-1, 0), 'C'],
		['C', Vector2(0, -1), 'L'],
		['C', Vector2(1, 0), 'L'],
		['C', Vector2(0, 1), 'S'],
		['C', Vector2(-1, 0), 'S'],
		['S', Vector2(0, -1), 'C'],
		['S', Vector2(1, 0), 'C'],
		['S', Vector2(0, 1), 'S'],
		['S', Vector2(0, -1), 'S'],
		['S', Vector2(1, 0), 'S'],
		['S', Vector2(-1, 0), 'S']
	]
var weights := {'L': 3, 'C': 2, 'S': 3}
var model: Model


func before_each() -> void:
	model = Model.new(size, weights, compatibilities)

#func test_find_minimum_entropy_coordinates() -> void:
#	assert_eq(model._find_minimum_entropy_coordinates(), Vector2(0, 0))
#	model._wavefunction._coefficients[2][1].pop_back()
#	assert_eq(model._find_minimum_entropy_coordinates(), Vector2(1, 2))


func test_propagate() -> void:
	model._wavefunction._coefficients[0][0].pop_back()
	assert_eq(model._wavefunction.get_coefficients(0, 0), ['L', 'C'])
	
	model._propagate(0, 0)
	assert_eq(model._wavefunction.get_coefficients(1, 0), ['L'])
	assert_eq(model._wavefunction.get_coefficients(1, 1), ['L', 'C'])
