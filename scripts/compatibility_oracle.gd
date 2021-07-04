# Check compatibilities validity
class_name CompatibilityOracle

var _compatibilities: Array


func _init(compatibilities: Array) -> void:
	self._compatibilities = compatibilities


# Return true if the compatibility is valid
func check(current_tile, direction, other_tile) -> bool:
	return _compatibilities.has([current_tile, direction, other_tile])
