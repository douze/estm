extends 'res://addons/gut/test.gd'

var CompatibilityOracle = load('res://scripts/compatibility_oracle.gd')

var compatibilities := [
		['L', Vector2(1, 0), 'L'],
		['L', Vector2(0, 1), 'L'],
		['C', Vector2(1, 0), 'L'],
		['C', Vector2(0, 1), 'S'],
		['S', Vector2(0, -1), 'C'],
		['S', Vector2(1, 0), 'C'],
		['S', Vector2(0, 1), 'S']
	]


func test_check() -> void:
	var oracle: CompatibilityOracle = CompatibilityOracle.new(compatibilities)
	assert_true(oracle.check('C', Vector2(0, 1), 'S'))
	assert_false(oracle.check('C', Vector2(0, -1), 'S'))
