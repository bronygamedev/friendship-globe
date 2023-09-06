extends Spatial
export var rotation_speed:float = 1
export var server_address = "http://127.0.0.1:2010"
onready var http = $HTTPRequest
onready var camera = $center/camera
onready var pin = $pindrop
onready var pin_button := $UI/bottom_popup/ColorRect/pin_button
onready var screen_size = get_viewport().size
onready var server = api.new(http,server_address)
var rainbow = preload("res://rainbow.tscn")
var last_camera_position
var camera_position
var earth_rotate = true
var mousedown
var isDragging
var rayOrigin = Vector3()
var rayEnd = Vector3()
var mouse3d
var mousePos 
var points:String
var can_place = true
var placing = false
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				mousedown = true
			else:
				mousedown = false
		if mousedown:
			earth_rotate = false
			isDragging = true
		else: 
			isDragging = false
			earth_rotate = true
		if event.button_index == BUTTON_RIGHT and can_place and placing:
			server.set_rainbow(Point.new(mouse3d["position"]))
			can_place = false
			pin.visible = false
			place_rainbow(mouse3d["position"])
func _ready():
	server.get_rainbows()
	


func _process(_delta):
	$UI/bottom_popup/ColorRect/rotate_button.pressed = !$UI/bottom_popup/ColorRect/pin_button.pressed
	if $UI/bottom_popup/ColorRect/rotate_button.pressed && !isDragging:
		earth_rotate = true
	else:
		earth_rotate = false
	if earth_rotate:
		$center.rotate_y(deg2rad(rotation_speed))
	mouse3d = cast_ray()
	if !mouse3d.empty():
		pin.transform.origin = mouse3d['position']
		pin.look_at(camera.global_transform.origin,Vector3.DOWN)
		if pin.transform.origin.y > 0:
			pin.rotation_degrees.x += 45
		else:
			pin.rotation_degrees.x -= 45


func cast_ray():
	var spaceState = get_world().direct_space_state
	mousePos = get_viewport().get_mouse_position()
	rayOrigin = camera.project_ray_origin(mousePos)
	rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var intersection = spaceState.intersect_ray(rayOrigin,rayEnd)
	return intersection


func _on_bottomPopupButton_pressed():
	$UI/bottom_popup/button_sound.play()
	if $"UI/bottom_popup/bottomPopupButton".pressed:
		$"UI/bottom_popup/AnimationPlayer".play("pop")
	else:
		$"UI/bottom_popup/AnimationPlayer".play_backwards("pop")


func _HTTPRequest_completed(_result, _response_code, _headers, body):
	if _response_code == 200:
		print(body.get_string_from_utf8())
		points = body.get_string_from_utf8()
	else :
		print(_result,' ', _response_code,' ', _headers,' ', body.get_string_from_utf8())


func _on_update_timer_timeout():
	server.get_rainbows()


func _place_button_click():
	if pin_button.pressed and can_place:
		pin.visible = true
		placing = true
	else:
		pin.visible = false
		placing = false
		
func place_rainbow(pos:Vector3):
	var r = rainbow.instance()
	get_node("Earth/rainbows").add_child(r)
	r.curve.add_point(pos,Vector3.ZERO,Vector3.ZERO)
	r.curve.add_point($Earth/cutiemarks.global_transform.origin,Vector3.ZERO,Vector3.ZERO)
