extends Control
@onready var nextScreen = get_parent().get_node("NextScreen")

func _input(event):
	print(nextScreen)
	if event is InputEventKey:
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Main.tscn")
