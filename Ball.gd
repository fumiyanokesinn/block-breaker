extends RigidBody2D

var ball_speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	# ボールが発射される向き
	var direction = Vector2(1, -1).normalized()
	var velocity = direction * ball_speed
	apply_impulse(velocity,Vector2.ZERO)

func _on_body_entered(body):
	if body.is_in_group("Blocks"):
		body.queue_free()
