extends Sprite2D

@onready var tween = create_tween()

func _ready():
	tween.tween_property(self,"modulate:a",0.0,0.5)
	tween.play()
	await get_tree().create_timer(0.5).timeout
	queue_free()
