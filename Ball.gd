extends RigidBody2D

const MAX_SPEED = 900
@export var speed_up = 10
@export var ball_speed = 430
var direction:Vector2
var velocity:Vector2
var paddle:Node

var mode = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	# ボールが発射される向きを定義する
	direction = Vector2(1, -1).normalized()
	velocity = direction * ball_speed
	paddle = get_parent().get_node("Bar")

func _on_body_entered(body):
	ball_speed += speed_up
	direction = linear_velocity.normalized() # 追加
	velocity = direction *  min(ball_speed, MAX_SPEED)
	if body.is_in_group("Blocks"):
		body.queue_free()
	if body.get_name() == "Bar":
		direction = (position - body.position).normalized()
		velocity = direction *  min(ball_speed, MAX_SPEED)
	linear_velocity = velocity

func _integrate_forces(state:PhysicsDirectBodyState2D):
	if mode ==0:
		state.transform.origin = Vector2(paddle.position.x, 500)
		if Input.is_action_just_pressed("launch_ball"):
			mode = 1
			state.apply_impulse(velocity)

