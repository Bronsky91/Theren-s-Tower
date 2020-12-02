extends Button

func _on_SpecialButton_mouse_entered():
	g.cursor_busy = true

func _on_SpecialButton_mouse_exited():
	g.cursor_busy = false
