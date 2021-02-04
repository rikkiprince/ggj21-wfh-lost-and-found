extends Node2D

onready var tilemap = get_node("TileMap")

var tourist_scene = preload("res://Tourist.tscn")
var conversation_panel_scene = preload("res://ConversationPanel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_tourist()

func new_tourist():
	var starting_location = select_tourist_starting_location()
	print("Starting at: "+str(starting_location))
	var destination_location = select_destination()
	place_new_tourist_at(starting_location, destination_location)
	launch_conversation_panel(starting_location, destination_location)

func place_new_tourist_at(starting_location, destination_cell):
	var world_coords = tilemap.map_to_world(starting_location)
	var tourist_node = tourist_scene.instance()
	tourist_node.position = world_coords
	tourist_node.list_of_directions = ["south","left","straight"]
	tourist_node.destination = destination_cell
	tourist_node.connect("tourist_arrived", self, "_on_Tourist_tourist_arrived")
	add_child(tourist_node)

func launch_conversation_panel(tourist_starting_location, destination_location):
	var conversation_node = conversation_panel_scene.instance()
	conversation_node.set_position(Vector2(132,425))
	if(tourist_starting_location.y > 11):
		conversation_node.set_position(Vector2(132,0))
	add_child(conversation_node)
	conversation_node.set_conversation_output("Hello there!\nI'm looking for [shake rate=5 level=10]the "+tilemap.name_of_tile(destination_location)+"[/shake].\nCould you tell me how to get there?")

func _on_Tourist_tourist_arrived(tourist):
	tourist.queue_free()

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
	
	var selected_cell = road_cells[randi() % road_cells.size()]
	#return Vector2(selected_cell.x, selected_cell.y)
	return Vector2(11,8)

func select_destination():
	var destination_cells = tilemap.get_used_cells_by_id(Tiles.HOSPITAL_ENTRANCE)
	destination_cells += tilemap.get_used_cells_by_id(Tiles.PARK_ENTRANCE)
	
	var selected_cell = destination_cells[randi() % destination_cells.size()]
	print("DESTINATION: "+str(selected_cell.x) + "," + str(selected_cell.y) + " : " + tilemap.name_of_tile(selected_cell))
	return selected_cell
