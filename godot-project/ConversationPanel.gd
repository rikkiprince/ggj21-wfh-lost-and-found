extends PanelContainer

onready var conversation_output_label = get_node("HBoxContainer/VBoxContainer/ConversationOutput")

var tourist
var starting_location
var destination_name
var destination_position
var rng_seed

signal directions_submitted(body)

func set_conversation_output(start_loc, d_name, position, s):
	starting_location = start_loc
	destination_name = d_name
	destination_position = position
	rng_seed = s
	conversation_output_label.bbcode_text = "Hello there!\nI'm looking for [shake rate=5 level=10]the "+d_name+"[/shake].\nCould you tell me how to get there?"

func directions_submitted(directions):
	var body = {}
	body.rng_seed = rng_seed
	body.tourist_start_position = starting_location
	body.destination_name = destination_name
	body.destination_position = destination_position
	body.directions = directions
	body.datetime = get_datetime_string()
	body.timestamp = {".sv": "timestamp"}
	emit_signal("directions_submitted", body)

func _ready():
	get_node("HBoxContainer/VBoxContainer/SpeechInput").grab_focus()

func get_datetime_string():
	var time = OS.get_datetime(true)
	var nameweekday= ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	var namemonth= ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var dayofweek = time["weekday"]   # from 0 to 6 --> Sunday to Saturday
	var day = time["day"]                         #   1-31
	var month= time["month"]               #   1-12
	var year= time["year"]             
	var hour= time["hour"]                     #   0-23
	var minute= time["minute"]             #   0-59
	var second= time["second"]             #   0-59
	return "%s, %02d %s %d %02d:%02d:%02d UTC" % [nameweekday[dayofweek], day, namemonth[month-1], year, hour, minute, second]
