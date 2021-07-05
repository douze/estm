# Decide how to choose the tile for the ouput matrix
class_name Wavefunction

var _width: int
var _height: int
var _weights: Dictionary
var _coefficients: Array


func _init(size: Vector2, weights: Dictionary) -> void:
	self._width = size.x
	self._height = size.y
	self._weights = weights
	_initialize_coefficients()


# Initialize all coefficients with the list of possible tiles
func _initialize_coefficients() -> void:
	var possible_tiles := _weights.keys()
	for y in _height:
		var row := []
		for x in _width:
			row.append(possible_tiles)
		_coefficients.append(row)


# Return the coefficient list at (x,y) position
func get_coefficients(x: int, y: int):
	return _coefficients[y][x]

