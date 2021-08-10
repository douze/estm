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
	for y in _height:
		var row := []
		for x in _width:
			row.append(_weights.keys())
		_coefficients.append(row)


# Return the coefficient list at coordinates
func get_coefficients(coordinates: Vector2) -> Array:
	return _coefficients[coordinates.y][coordinates.x]


# Return true if each tile list is collapsed (ie size=1) for each coefficients
func is_fully_collapsed() -> bool:
	for y in _height:
		var row: Array = _coefficients[y]
		for x in _width:
			var tiles: Array = row[x]
			if tiles.size() != 1:
				return false
	return true


# Compute the shannon entropy at coordinates
func compute_shannon_entropy(coordinates: Vector2) -> float:
	var sum_of_weights: int = 0
	var sum_of_weight_log_weights: float = 0
	for tile in get_coefficients(coordinates):
		var weight: int = _weights[tile]
		sum_of_weights += weight
		sum_of_weight_log_weights += weight * log(weight)
	if sum_of_weights == 0: 
		return 1.0
	return log(sum_of_weights) - (sum_of_weight_log_weights / sum_of_weights)


# Return the weights corresponding to the tiles only
func _get_valid_weights(tiles: Array) -> Dictionary:
	var valid_weights := {}
	for key in _weights.keys():
		if tiles.has(key):
			valid_weights[key] = _weights[key]
	return valid_weights


# Return the sum of occurrences for the weights
func _get_total_occurrences(valid_weights: Dictionary) -> int:
	var total_occurrences := 0
	for value in valid_weights.values():
		total_occurrences += value
	return total_occurrences


# Collapse the coefficients at coordinates to a single tile
func collapse(coordinates: Vector2) -> void:
	var tiles := get_coefficients(coordinates)
	if tiles.empty(): return
	var valid_weights := _get_valid_weights(tiles)
	var total_occurrences := _get_total_occurrences(valid_weights)
	var random_weight: float = randf() * total_occurrences
	
	var chosen = null
	for key in valid_weights:
		random_weight -= valid_weights[key]
		if random_weight < 0:
			chosen = key
			break
	_coefficients[coordinates.y][coordinates.x] = [chosen]


# Constrain the coefficients at coordinates removing forbidden tile
func constrain(coordinates: Vector2, forbidden_tile: String) -> void:
	get_coefficients(coordinates).erase(forbidden_tile)

