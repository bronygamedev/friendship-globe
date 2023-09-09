extends Spatial
export var rotation_speed:float = 1
export var server_address = "http://127.0.0.1:2010"
export var earth_rotate = true
onready var http = $HTTPRequest
onready var camera = $center/camera
onready var pin = $pindrop
onready var pin_button := $UI/bottom_popup/ColorRect/pin_button
onready var screen_size = get_viewport().size
onready var server = api.new(http,server_address)
onready var cutiemarks = $Globe/Earth/cutiemarks
var rainbow = preload("res://rainbow.tscn")
var last_camera_position
var camera_position
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
			$place_timer.start()
func _ready():
	$UI/bottom_popup/ColorRect/rotate_button.pressed = earth_rotate
	server.get_rainbows()
	


func _process(_delta):
	cutiemarks.rotate_y(deg2rad(-1))
	if $UI/bottom_popup/ColorRect/rotate_button.pressed && !isDragging:
		earth_rotate = true
	else:
		earth_rotate = false
	if earth_rotate:
		$Globe/Earth.rotate_y(deg2rad(rotation_speed))
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
	var path = Path.new()
	var mesh = CSGPolygon.new()
	$Globe/Rainbows.add_child(path)
	path.add_child(mesh)
	path.look_at(Vector3.ZERO,Vector3.UP)
	mesh.polygon = PoolVector2Array([Vector2(0, 0), Vector2(0, 0.01), Vector2(0.1, 0.01), Vector2(0.1, 0)])
	mesh.material = load("res://rainbow_shadermaterial.tres")
	mesh.mode = CSGPolygon.MODE_PATH
	mesh.path_interval = 0.01
	mesh.path_node = path.get_path()
	path.curve.add_point(pos,Vector3.ZERO,Vector3.ZERO)
	path.curve.add_point(Vector3(pos.x,cutiemarks.global_transform.origin.y,pos.z),Vector3.ZERO,Vector3.ZERO)
	path.curve.add_point(cutiemarks.global_transform.origin,Vector3.ZERO,Vector3.ZERO)


func _on_place_timer_timeout():
	can_place = true


func _on_Button_button_up():
	var packed_scene = PackedScene.new()
	packed_scene.pack(self)
	ResourceSaver.save("res://Scene.tscn", packed_scene)
