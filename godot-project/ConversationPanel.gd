extends PanelContainer

onready var conversation_output_label = get_node("HBoxContainer/VBoxContainer/ConversationOutput")

func set_conversation_output(text):
	conversation_output_label.bbcode_text = text