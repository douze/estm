# Orchestrate the wavefunction collapse strategy
class_name Model

var _output_size: Vector2
var _weights: Dictionary
var _compatibilites: Array
var _wavefunction: Wavefunction
var _oracle: CompatibilityOracle


func _init(output_size: Vector2, weights: Dictionary, compatibilities: Array) -> void:
	self._output_size = output_size
	self._weights = weights
	self._compatibilites = compatibilities
	self._wavefunction = Wavefunction.new(_output_size, _weights)
	self._oracle = CompatibilityOracle.new(compatibilities)


# Collapse the wavefunction until fully collapsed
func run() -> void:
	while not _wavefunction.is_fully_collapsed():
		_iterate()


# Perform an iteration of the wfc algorithm
func _iterate() -> void:
	var minimum_entropy_coordinates := _find_minimum_entropy_coordinates()
	_wavefunction.collapse(minimum_entropy_coordinates)
	_propagate(minimum_entropy_coordinates)


# Return the coordinates of the coefficients with the minimum entropy
func _find_minimum_entropy_coordinates() -> Vector2:
	var min_entropy := -1.0
	var min_entropy_coordinates: Vector2
	for y in _output_size.y:
		for x in _output_size.x:
			if _wavefunction.get_coefficients(Vector2(x, y)).size() == 1:
				continue
			var entropy: float = _wavefunction.compute_shannon_entropy(Vector2(x, y))
			var entropy_plus_noise: float = entropy - (randf() / 1000) # not sure about it
			if min_entropy == -1.0 or entropy_plus_noise < min_entropy:
				min_entropy = entropy_plus_noise
				min_entropy_coordinates = Vector2(x, y)
	return min_entropy_coordinates


# Propagate the wavefunction, for starting_coordinates then from restricted tiles
func _propagate(starting_coordinates: Vector2) -> void:
	var stack := [ starting_coordinates ]
	
	while stack.size() > 0:
		var coordinates: Vector2 = stack.pop_back()
		var tiles: Array = _wavefunction.get_coefficients(coordinates)
		for direction in Matrix.get_valid_directions(coordinates, _output_size):
			var other_coordinates: Vector2 = coordinates + direction
			var other_tiles := _wavefunction.get_coefficients(other_coordinates).duplicate()
			for other_tile in other_tiles:
				var other_tile_is_valid := false
				for current_tile in tiles:
					other_tile_is_valid = other_tile_is_valid or _oracle.check(current_tile, direction, other_tile)
				if not other_tile_is_valid:
					_wavefunction.constrain(other_coordinates, other_tile)
					stack.append(other_coordinates)
