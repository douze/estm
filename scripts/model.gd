# Orchestrate the wavefunction collapse strategy
class_name Model

var _output_size: Vector2
var _weights: Dictionary
var _compatibilites: Array


func _init(output_size: Vector2, weights: Dictionary, compatibilities: Array) -> void:
	self._output_size = output_size
	self._weights = weights
	self._compatibilites = compatibilities


