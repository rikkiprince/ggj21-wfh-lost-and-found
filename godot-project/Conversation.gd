extends RichTextLabel

func _on_Speech_text_entered(new_text):
	new_text = animate_key_words(new_text)
	
	push_align(RichTextLabel.ALIGN_RIGHT)
	append_bbcode(new_text)
	pop()
	scroll_to_line(get_line_count()-1)

func animate_key_words(new_text):
	new_text = new_text.replacen("left", "[shake]left[/shake]")
	return new_text
