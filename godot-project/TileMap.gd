extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("0,0: "+str(get_cell(0,0)))
	print("10,0: "+str(get_cell(10,0)))
	print("0,10: "+str(get_cell(0,10)))
	print("10,10: "+str(get_cell(10,10)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func is_on_intersection(tourist):
	var map_position_of_tourist = world_to_map(tourist.position)
	#print(map_position_of_tourist)
	var cell_on = get_cellv(map_position_of_tourist)
