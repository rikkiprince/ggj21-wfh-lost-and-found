extends RichTextLabel

func _on_Speech_text_entered(new_text):
	push_align(RichTextLabel.ALIGN_RIGHT)
	add_text(new_text)
	pop()
