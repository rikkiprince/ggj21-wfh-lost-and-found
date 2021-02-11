extends KinematicBody2D


# Declare member variables here. Examples:
export (int) var speed = 30
var velocity = Vector2()
onready var tilemap = get_parent().get_node("TileMap")
var position_on_map = Vector2()
var direction = Vector2()

signal tourist_arrived(tourist)

const N = Vector2(0,-1)
const S = Vector2(0,1)
const E = Vector2(1,0)
const W = Vector2(-1,0)
var compass_directions = [N, S, E, W]

const STOOD_STILL = Vector2(0,0)

export(Array,String) var list_of_directions #["south","left","straight","right","west"]

var destination = Vector2(18,11)

var compass_directions_regex
var relative_directions_regex

# Called when the node enters the scene tree for the first time.
func _ready():
	position_on_map = tilemap.position_on_map(self)
	direction = STOOD_STILL
	
	compass_directions_regex = RegEx.new()
	compass_directions_regex.compile("north|east|south|west")
	relative_directions_regex = RegEx.new()
	relative_directions_regex.compile("left|right|straight|up|down")


func pick_random_direction():
	return compass_directions[randi() % compass_directions.size()]
	
func relative_to_compass(current_direction, relative_turn):
	match relative_turn.to_lower():
		"left":
			return current_direction.rotated(deg2rad(-90))
		"right":
			return current_direction.rotated(deg2rad(90))
		_:
			return current_direction

func screen_relative_to_compass(current_direction, relative_direction):
	match relative_direction.to_lower():
		"left":
			return W
		"right":
			return E
		"up":
			return N
		"down":
			return S
		"straight":
			print("Which way is straight? I'm stood still!")
		_:
			return current_direction

func convert_direction_text_to_vector(current_direction, direction_text):
	direction_text = direction_text.to_lower()
	var compass_match = compass_directions_regex.search(direction_text)
	if(compass_match):
		var compass_direction = compass_match.get_string()
		print("Got compass direction: "+compass_direction)
		var new_compass_direction = compass_direction[0].to_upper()
		if(new_compass_direction in self):
			return self.get(new_compass_direction)
		else:
			print("ERROR: Could not find vector for compass direction "+str(new_compass_direction))
	else:
		var relative_match = relative_directions_regex.search(direction_text)
		if(relative_match):
			var relative_direction = relative_match.get_string()
			if(direction == STOOD_STILL):
				return screen_relative_to_compass(current_direction, relative_direction)
			else:
				return relative_to_compass(current_direction, relative_direction)
		else:
			print("WARNING: Unknown direction "+str(direction_text))
	return STOOD_STILL # TODO: Make this "straight"?

func get_next_direction(current_direction):
	var direction_text = list_of_directions.pop_front()
	print("\n---\n")
	print("= Processing: '"+direction_text+"'")
	if(direction_text == null or direction_text == ""):
		return STOOD_STILL # pick_random_direction() ?
	
	var new_direction = convert_direction_text_to_vector(current_direction, direction_text)
	if(next_cell_valid(new_direction)):
		return new_direction
	else:
		print("New direction "+str(new_direction)+" is not possible.")
	
	return STOOD_STILL # pick_random_direction()

func next_cell_valid(new_direction):
	var current_cell = tilemap.position_on_map(self)
	var new_cell = current_cell + new_direction
	var name_of_next_cell = tilemap.name_of_tile(new_cell)
	return ["HorizontalRoad", "VerticalRoad", "Intersection"].has(name_of_next_cell)

func kickstart():
	direction = get_next_direction(direction)

func _physics_process(delta):
	var new_position_on_map = tilemap.position_on_map(self)
	if(new_position_on_map != position_on_map):
		# Am I next to destination?
		if(new_position_on_map.distance_to(destination) <= 1):
			print("SUCCESS: Made it to "+str(destination))
			direction = STOOD_STILL
			emit_signal("tourist_arrived", self)
		
		# Is tourist now on an intersection?
		if(tilemap.is_on_intersection(self)):
			print("I'm at an intersection...")
			direction = get_next_direction(direction)
			# TODO: Check direction has road
			# TODO: If possible, don't U-turn
			print("Changed direction: "+str(direction))
	position_on_map = new_position_on_map
	
	velocity = direction.normalized() * speed
	velocity = move_and_slide(velocity)
	
