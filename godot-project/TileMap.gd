extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func is_on_intersection(tourist):
	var map_position_of_tourist = world_to_map(tourist.position)
	#print(map_position_of_tourist)
	var tile_on = get_cellv(map_position_of_tourist)
	var tile_name = tile_set.tile_get_name(tile_on)
	if(tile_name == "Intersection"):
		return true
	return false

func name_of_tile(tile_position):
	return tile_set.tile_get_name(get_cellv(tile_position))

func position_on_map(tourist):
	return world_to_map(tourist.position)
