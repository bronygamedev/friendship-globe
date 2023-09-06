extends Node
class_name api
var http:HTTPRequest
var server_address

func _init(http_client:HTTPRequest,address:String):
	http = http_client
	server_address = address
	

func get_rainbows():
	http.request(server_address + '/api/get_points')

func set_rainbow(data:Point):
	var jstr = JSON.print(data.get_dict())
	http.request(server_address + "/api/set_point",[],true,2,jstr) 
