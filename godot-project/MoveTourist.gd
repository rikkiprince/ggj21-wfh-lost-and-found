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
var directions = [N, S, E, W]

const STOOD_STILL = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	position_on_map = tilemap.position_on_map(self)
	direction = pick_random_direction()
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func pick_random_direction():
	return directions[randi() % directions.size()]


func _physics_process(delta):
	var new_position_on_map = tilemap.position_on_map(self)
	if(new_position_on_map != position_on_map):
		if(tilemap.is_on_intersection(self)):
			direction = pick_random_direction()
			# TODO: Check direction has road
			# TODO: If possible, don't U-turn
			print("Changed direction: "+str(direction))
	position_on_map = new_position_on_map
	
	velocity = direction.normalized() * speed
	velocity = move_and_slide(velocity)
	
