@tool
extends Node3D
@export var earth:Node
func _process(delta):
	earth.rotate_y(.01)
