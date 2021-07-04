extends 'res://addons/gut/test.gd'

var Matrix = load('res://scripts/matrix.gd')

var small_input_matrix: Array


func before_all() -> void:
	small_input_matrix = [
		['L','L'],
		['C','L'],
		['S','C'],
		['S','S']
	]


func test_to_string() -> void:
	var matrix: Matrix = Matrix.new(small_input_matrix, 2, 4)
	assert_eq(str(matrix), "L L\nC L\nS C\nS S")


func test_get_valid_directions() -> void:
	var matrix: Matrix = Matrix.new(small_input_matrix, 2, 4)
	
	var directions_00 := matrix.get_valid_directions(0, 0)
	assert_eq(directions_00.size(), 2)
	assert_eq(directions_00, [Vector2(1, 0), Vector2(0, 1)])
	
	var directions_02 := matrix.get_valid_directions(0, 2)
	assert_eq(directions_02.size(), 3)
	assert_eq(directions_02, [Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)])
	
	var directions_13 := matrix.get_valid_directions(1, 3)
	assert_eq(directions_13.size(), 2)
	assert_eq(directions_13, [Vector2(-1, 0), Vector2(0, -1)])


func test_parse() -> void:
	var matrix: Matrix = Matrix.new(small_input_matrix, 2, 4)
	var result := matrix.parse()
	var compatibilities: Array = result[0]
	var weights: Dictionary = result[1]

	assert_eq_shallow(weights, {'C':2, 'L':3, 'S':3})
	assert_eq(compatibilities.size(), 16)
	# 0 0
	assert_has(compatibilities, ['L', Vector2(1, 0), 'L'])
	assert_has(compatibilities, ['L', Vector2(0, 1), 'C'])
	# 1 0
	assert_has(compatibilities, ['L', Vector2(-1, 0), 'L'])
	assert_has(compatibilities, ['L', Vector2(0, 1), 'L'])
	# 0 1
	assert_has(compatibilities, ['C', Vector2(0, -1), 'L'])
	assert_has(compatibilities, ['C', Vector2(1, 0), 'L'])
	assert_has(compatibilities, ['C', Vector2(0, 1), 'S'])
	# 1 1
	assert_has(compatibilities, ['L', Vector2(0, -1), 'L'])
	assert_has(compatibilities, ['L', Vector2(-1, 0), 'C'])
	assert_has(compatibilities, ['L', Vector2(0, 1), 'C'])
	# 0 2
	assert_has(compatibilities, ['S', Vector2(0, -1), 'C'])
	assert_has(compatibilities, ['S', Vector2(1, 0), 'C'])
	assert_has(compatibilities, ['S', Vector2(0, 1), 'S'])
	# 1 2
	assert_has(compatibilities, ['C', Vector2(0, -1), 'L'])
	assert_has(compatibilities, ['C', Vector2(-1, 0), 'S'])
	assert_has(compatibilities, ['C', Vector2(0, 1), 'S'])
	# 0 3
	assert_has(compatibilities, ['S', Vector2(0, -1), 'S'])
	assert_has(compatibilities, ['S', Vector2(1, 0), 'S'])
	# 1 3
	assert_has(compatibilities, ['S', Vector2(0, -1), 'C'])
	assert_has(compatibilities, ['S', Vector2(-1, 0), 'S'])

