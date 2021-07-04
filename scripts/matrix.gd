# Store the input data
class_name Matrix

var _raw_data: Array
var _width: int
var _height: int

var _UP = Vector2(0, 1)
var _DOWN = Vector2(0, -1)
var _LEFT = Vector2(-1, 0)
var _RIGHT = Vector2(1, 0)
var _DIRECTIONS = [_UP, _DOWN, _LEFT, _RIGHT]


func _init(raw_data: Array, width: int, height: int) -> void:
	self._raw_data = raw_data
	self._width = width
	self._height = height


# Return the matrix as String for console display
func _to_string() -> String:
	var result := ""
	for y in _height:
		for x in _width:
			if x:
				result += " "
			result += str(_raw_data[y][x])
		if y != _height - 1:
			result += '\n'
	return result


# Return the valid directions from a (x,y) position
func get_valid_directions(x: int, y: int) -> Array:
	var valid_directions := []

	if x > 0: valid_directions.append(_LEFT)
	if x < _width - 1: valid_directions.append(_RIGHT)
	if y > 0: valid_directions.append(_DOWN)
	if y < _height - 1: valid_directions.append(_UP)

	return valid_directions


# Return the compatibilities ("this tile has to its up/down/left/right that tile") and weights ("this tile occurs n times")
func parse() -> Array:
	var compatibilities := []
	var weights := {}

	for y in _height:
		var row: Array = _raw_data[y]
		for x in _width:
			var current_tile: String = row[x]
			if !(current_tile in weights):
				weights[current_tile] = 0
			weights[current_tile] += 1

			for direction in get_valid_directions(x, y):
				var other_tile: String = _raw_data[y + direction[1]][x + direction[0]]
				var record := [current_tile, direction, other_tile]
				if !compatibilities.has(record):
					compatibilities.append(record)

	return [compatibilities, weights]



