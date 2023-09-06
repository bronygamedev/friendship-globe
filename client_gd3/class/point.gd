class_name Point

extends Node

var x: float
var y: float
var z: float

func _init(points:Vector3):
	x = points.x
	y = points.y
	z = points.z
	
func get_dict():
	return {
		"x":x,
		"y":y,
		"z":z
	}
