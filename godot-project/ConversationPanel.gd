extends PanelContainer

onready var conversation_output_label = get_node("HBoxContainer/VBoxContainer/ConversationOutput")

var tourist
var destination_name
var destination_position
var rng_seed

signal directions_submitted(body)

func set_conversation_output(d_name, position, s):
	destination_name = d_name
	destination_position = position
	rng_seed = s
	conversation_output_label.bbcode_text = "Hello there!\nI'm looking for [shake rate=5 level=10]the "+d_name+"[/shake].\nCould you tell me how to get there?"

func directions_submitted(directions):
	var body = {}
	body.rng_seed = rng_seed
	body.tourist_start_position = tourist.position
	body.destination_name = destination_name
	body.destination_position = destination_position
	body.directions = directions
	emit_signal("directions_submitted", body)

func _ready():
	get_node("HBoxContainer/VBoxContainer/SpeechInput").grab_focus()
