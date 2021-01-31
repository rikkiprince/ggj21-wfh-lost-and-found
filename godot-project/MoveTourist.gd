extends KinematicBody2D


# Declare member variables here. Examples:
export (int) var speed = 30
var velocity = Vector2()
onready var tilemap = get_parent().get_node("TileMap")

func get_input():
	velocity = Vector2()
	velocity.x = -1
	velocity = velocity.normalized() * speed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	tilemap.is_on_intersection(self)
