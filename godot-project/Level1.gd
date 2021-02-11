extends Node2D

onready var tilemap = get_node("TileMap")

var tourist_scene = preload("res://Tourist.tscn")
var conversation_panel_scene = preload("res://ConversationPanel.tscn")

var rng = RandomNumberGenerator.new()
var s

# Called when the node enters the scene tree for the first time.
func _ready():
	#randomize()
	#var new_seed = randi()
	#print("SEED: "+str(new_seed))
	#rng.randomize()
	rng.seed = 1366326005678505183 #1882199055
	s = rng.seed
	print("SEED: "+str(s))
	new_tourist()

func new_tourist():
	var starting_location = select_tourist_starting_location()
	print("Starting at: "+str(starting_location))
	var destination_location = select_destination()
	var tourist = place_new_tourist_at(starting_location, destination_location)
	launch_conversation_panel(tourist, destination_location)

func place_new_tourist_at(starting_location, destination_cell):
	var world_coords = tilemap.map_to_world(starting_location)
	var tourist_node = tourist_scene.instance()
	tourist_node.position = world_coords
	tourist_node.list_of_directions = ["south","left","straight"]
	tourist_node.destination = destination_cell
	tourist_node.connect("tourist_arrived", self, "_on_Tourist_tourist_arrived")
	add_child(tourist_node)
	return tourist_node

func launch_conversation_panel(tourist, destination_location):
	var conversation_node = conversation_panel_scene.instance()
	conversation_node.connect("directions_submitted", self, "_on_ConversationPanel_directions_submitted")
	conversation_node.set_position(Vector2(132,425))
	if(tourist.position.y > 400):
		conversation_node.set_position(Vector2(132,0))
	add_child(conversation_node)
	conversation_node.tourist = tourist
	var destination_name = tilemap.name_of_tile(destination_location)
	conversation_node.set_conversation_output(destination_name, destination_location, s)

func _on_Tourist_tourist_arrived(tourist):
	tourist.queue_free()
	new_tourist()

enum Tiles {
	HORIZONTAL_ROAD,
	VERTICAL_ROAD,
	HOSPITAL_BUILDING,
	PUB,
	PARK_SPACE,
	HOSPITAL_ENTRANCE,
	INTERSECTION,
	HOUSE_BUILDING,
	PARK_ENTRANCE,
}

func select_tourist_starting_location():
	var road_cells = tilemap.get_used_cells_by_id(Tiles.HORIZONTAL_ROAD)
	road_cells += tilemap.get_used_cells_by_id(Tiles.VERTICAL_ROAD)
	
	var selected_cell = road_cells[rng.randi() % road_cells.size()]
	return Vector2(selected_cell.x, selected_cell.y)

func select_destination():
	var destination_cells = tilemap.get_used_cells_by_id(Tiles.HOSPITAL_ENTRANCE)
	destination_cells += tilemap.get_used_cells_by_id(Tiles.PARK_ENTRANCE)
	
	var random_index = rng.randi() % destination_cells.size()
	print("random_index: "+str(random_index))
	var selected_cell = destination_cells[random_index]
	print("DESTINATION: "+str(selected_cell.x) + "," + str(selected_cell.y) + " : " + tilemap.name_of_tile(selected_cell))
	return selected_cell

func _on_ConversationPanel_directions_submitted(body):
	log_to_firebase(body)

func log_to_firebase(body):
	print(body)
	print(JSON.print(body))
	var json_body = JSON.print(body)
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_HTTPRequest_request_completed")
	var error = http_request.request(
		"https://lost-and-found-a3a8b-default-rtdb.firebaseio.com/test.json",
		[],
		true,
		HTTPClient.METHOD_POST,
		json_body
	)
	if(error != OK):
		print("ERROR sending HTTP")
		push_error("An error occred in the HTTP request.")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("result: "+str(result))
	print("code: "+str(response_code))
	print("headers: "+str(headers))
	print(body)
