extends RichTextLabel

onready var conversation_panel = find_parent("ConversationPanel")
var directions = []

func _on_Speech_text_entered(new_text):
	directions.push_back(new_text)
	
	var display_text = animate_key_words(new_text)
	
	push_align(RichTextLabel.ALIGN_RIGHT)
	append_bbcode(display_text)
	pop()
	scroll_to_line(get_line_count()-1)
	
	if(["bye","good luck","arrive","destination"].has(new_text)):
		print("End of directions")
		conversation_panel.tourist.list_of_directions = directions
		conversation_panel.tourist.kickstart()
		conversation_panel.queue_free()

func animate_key_words(new_text):
	new_text = new_text.replacen("left", "[shake]left[/shake]")
	return new_text
