extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var tilemap = get_node("TileMap")

var tourist_scene = preload("res://Tourist.tscn")
var conversation_panel_scene = preload("res://ConversationPanel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	new_tourist()

func new_tourist():
	# select_tourist_starting_location()
	# select_destination()
	place_new_tourist_at(11,8)
	launch_conversation_panel()

func place_new_tourist_at(x,y):
	var world_coords = tilemap.map_to_world(Vector2(x,y))
	var tourist_node = tourist_scene.instance()
	tourist_node.position = world_coords
	tourist_node.list_of_directions = ["south","left","straight"]
	add_child(tourist_node)

func launch_conversation_panel():
	var conversation_node = conversation_panel_scene.instance()
	conversation_node.set_position(Vector2(132,425))
	add_child(conversation_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# TODO: Set up game data specific to Level 1
# e.g. potential destination co-ords
#      tourist starting points?
