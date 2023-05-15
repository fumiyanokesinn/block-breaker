extends Control


func _input(event):
	if Input.is_action_just_pressed("ui_accept") && visible:
		$PushKeyboard.play()
		await get_tree().create_timer(0.1).timeout
		hide()
		get_tree().paused = false
