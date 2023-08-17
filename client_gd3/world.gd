tool
extends Spatial
export var rotation_speed:float = 1
var last_camera_position
var camera_position
var earth_rotate = true
var mousedown
var isDragging
func _ready():
	pass
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				mousedown = true
			else:
				mousedown = false

	if event is InputEventMouseMotion and mousedown:
		earth_rotate = false
		isDragging = true
	else: 
		isDragging = false
		earth_rotate = true
func _process(delta):
	if $UI/bottom_popup/rotate_button.pressed && !isDragging:
		earth_rotate = true
	else:
		earth_rotate = false
	if earth_rotate:
		$Earth.rotate_y(deg2rad(rotation_speed))


func _on_bottomPopupButton_pressed():
	if $"UI/bottom_popup/bottomPopupButton".pressed:
		$"UI/bottom_popup/AnimationPlayer".play("pop")
	else:
		$"UI/bottom_popup/AnimationPlayer".play_backwards("pop")
