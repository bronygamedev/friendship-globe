 extends Spatial
export var rotation_speed:float = 1
export var server_address = "http://127.0.0.1:2010"
var last_camera_position
var camera_position
var earth_rotate = true
var mousedown
var isDragging
onready var http = $HTTPRequest

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

func _ready():
	_on_api_button_up()
func _process(_delta):
	if $UI/bottom_popup/ColorRect/rotate_button.pressed && !isDragging:
		earth_rotate = true
	else:
		earth_rotate = false
	if earth_rotate:
		$Earth.rotate_y(deg2rad(rotation_speed))


func _on_bottomPopupButton_pressed():
	$UI/bottom_popup/button_sound.play()
	if $"UI/bottom_popup/bottomPopupButton".pressed:
		$"UI/bottom_popup/AnimationPlayer".play("pop")
	else:
		$"UI/bottom_popup/AnimationPlayer".play_backwards("pop")


func _HTTPRequest_completed(_result, _response_code, _headers, body):
	if _response_code == 200:
		print(body.get_string_from_utf8())
	else :
		print(_result,'', _response_code,'', _headers,'', body)


func _on_api_button_up():
	http.request(server_address + '/api/get_points')


func _on_update_timer_timeout():
	_on_api_button_up()
