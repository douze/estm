extends 'res://addons/gut/test.gd'

var Wavefunction = load('res://scripts/wavefunction.gd')

var size := Vector2(3, 5)
var weights := {'C': 3, 'L' : 4, 'S': 2}
var wavefunction: Wavefunction


func before_each() -> void:
	wavefunction = Wavefunction.new(size, weights)


func test_initial_coefficients() -> void:
	for y in size.y:
		var row: Array = wavefunction._coefficients[y]
		for x in size.x:
			var tiles: Array = row[x]
			assert_eq(tiles, ['C', 'L', 'S'])


func test_get_coefficients() -> void:
	assert_eq(wavefunction.get_coefficients(0, 0), ['C', 'L', 'S'])
	wavefunction._coefficients[1][2].pop_back()
	assert_eq(wavefunction.get_coefficients(2, 1), ['C', 'L'])


func test_is_fully_collapsed() -> void:
	for y in size.y:
		var row: Array = wavefunction._coefficients[y]
		for x in size.x:
			var tiles: Array = row[x]
			tiles.pop_back()
			tiles.pop_back()
	assert_true(wavefunction.is_fully_collapsed())
	wavefunction._coefficients[0][0].append('S')
	assert_false(wavefunction.is_fully_collapsed())


func test_compute_shannon_entropy() -> void:
	assert_almost_eq(wavefunction.compute_shannon_entropy(0, 0), 1.060857, 0.0000001)


func test_get_valid_weights() -> void:
	assert_eq_shallow(wavefunction._get_valid_weights(['C', 'L']), {'C': 3, 'L' : 4})


func test_get_total_occurrences() -> void:
	assert_eq(wavefunction._get_total_occurrences({'C': 3, 'L' : 4}), 7)


func test_collapse() -> void:
	wavefunction.collapse(2, 3)
	assert_eq(wavefunction.get_coefficients(2, 3).size(), 1)


func test_constain() -> void:
	wavefunction.constrain(Vector2(1, 2), 'S')
	assert_eq(wavefunction.get_coefficients(1, 2), ['C', 'L'])
