extends Node3D
@export var earth:MeshInstance3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func _process(delta):
	earth.rotate_y(.01)
