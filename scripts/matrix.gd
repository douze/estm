# Store the input data
class_name Matrix

var _raw_data: Array
var _width: int
var _height: int


func _init(raw_data: Array) -> void:
	self._raw_data = raw_data
	assert(_raw_data.size() > 0)
	self._height = _raw_data.size()
	assert(typeof(_raw_data[0]) == TYPE_ARRAY and _raw_data[0].size() > 0)
	self._width = _raw_data[0].size()
	assert(is_size_constant())


# Check that all rows have the same size
func is_size_constant() -> bool:
	var is_valid: bool = true
	var first_row_size: int = _raw_data[0].size()
	for i in range(1, _raw_data.size()):
		var next_row: Array = _raw_data[i]
		is_valid = is_valid and next_row.size() == first_row_size
	return is_valid


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


# Return the valid directions from a coordinates, for matrix_size
static func get_valid_directions(coordinates: Vector2, matrix_size: Vector2) -> Array:
	var valid_directions := []

	if coordinates.x > 0: valid_directions.append(Vector2(-1, 0))
	if coordinates.x < matrix_size.x - 1: valid_directions.append(Vector2(1, 0))
	if coordinates.y > 0: valid_directions.append(Vector2(0, -1))
	if coordinates.y < matrix_size.y - 1: valid_directions.append(Vector2(0, 1))

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

			for direction in get_valid_directions(Vector2(x, y), Vector2(_width, _height)):
				var other_tile: String = _raw_data[y + direction[1]][x + direction[0]]
				var record := [current_tile, direction, other_tile]
				if !compatibilities.has(record):
					compatibilities.append(record)

	return [compatibilities, weights]
