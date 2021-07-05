extends 'res://addons/gut/test.gd'

var Model = load('res://scripts/model.gd')

var compatibilities := [
		['L', Vector2(1, 0), 'L'],
		['L', Vector2(0, 1), 'L'],
		['C', Vector2(1, 0), 'L'],
		['C', Vector2(0, 1), 'S'],
		['S', Vector2(0, -1), 'C'],
		['S', Vector2(1, 0), 'C'],
		['S', Vector2(0, 1), 'S']
	]

var weights := {'L': 3, 'C': 2, 'S': 3}


