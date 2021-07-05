extends 'res://addons/gut/test.gd'

var Wavefunction = load('res://scripts/wavefunction.gd')

var size := Vector2(3, 5)
var weights := {'C': 3, 'L' : 4, 'S': 2}


func test_initial_coefficients() -> void:
	var wavefunction: Wavefunction = Wavefunction.new(size, weights)
	for y in size.y:
		var row: Array = wavefunction._coefficients[y]
		for x in size.x:
			var coefficients: Array = row[x]
			assert_eq(coefficients, ['C', 'L', 'S'])


func test_get_coefficients() -> void:
	var wavefunction: Wavefunction = Wavefunction.new(size, weights)
	assert_eq(wavefunction.get_coefficients(0, 0), ['C', 'L', 'S'])
	wavefunction._coefficients[1][2].pop_back()
	assert_eq(wavefunction.get_coefficients(2, 1), ['C', 'L'])
