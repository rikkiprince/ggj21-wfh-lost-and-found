extends KinematicBody2D


# Declare member variables here. Examples:
export (int) var speed = 30
var velocity = Vector2()
onready var tilemap = get_parent().get_node("TileMap")
var position_on_map = Vector2()
var direction = Vector2()

const N = Vector2(0,-1)
const S = Vector2(0,1)
const E = Vector2(1,0)
const W = Vector2(-1,0)
var compass_directions = [N, S, E, W]

const STOOD_STILL = Vector2(0,0)

var list_of_directions = ["south","left","straight","right","west"]

# Called when the node enters the scene tree for the first time.
func _ready():
	position_on_map = tilemap.position_on_map(self)
	direction = E
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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

func get_next_direction():
	var direction_text = list_of_directions.pop_front()
	if(["north","east","south","west"].has(direction_text)):
		print("Got compass direction: "+direction_text)
		var new_compass_direction = direction_text[0].to_upper()
		if(new_compass_direction in self):
			return self.get(new_compass_direction)
		else:
			print("ERROR: Could not find compass direction "+str(new_compass_direction))
	elif(["left","right","straight"].has(direction_text)):
		return relative_to_compass(direction, direction_text)
	
	return STOOD_STILL # pick_random_direction()

func _physics_process(delta):
	var new_position_on_map = tilemap.position_on_map(self)
	if(new_position_on_map != position_on_map):
		# TODO: Am I next to destination?
		if(tilemap.is_on_intersection(self)):
			direction = get_next_direction()
			# TODO: Check direction has road
			# TODO: If possible, don't U-turn
			print("Changed direction: "+str(direction))
	position_on_map = new_position_on_map
	
	velocity = direction.normalized() * speed
	velocity = move_and_slide(velocity)
	
