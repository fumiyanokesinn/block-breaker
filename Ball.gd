extends RigidBody2D

const MAX_SPEED = 800
@export var speed_up = 10
@export var ball_speed = 430
@export var mode = 0;
var direction:Vector2
var velocity:Vector2
var paddle:CharacterBody2D
var blockHit:Node
var wallHit:Node
@onready var ballPosition = position

# Called when the node enters the scene tree for the first time.
func _ready():
	paddle = get_parent().get_node("Bar")
	blockHit = get_parent().get_node("BlockHit")
	wallHit = get_parent().get_node("WallHit")

func _on_body_entered(body):
	ball_speed += speed_up
	direction = linear_velocity.normalized() # 追加
	velocity = direction *  min(ball_speed, MAX_SPEED)
	if body.is_in_group("Blocks"):
		blockHit.play()
		body.hide()
		body.set_collision_layer_value(1,false)
		body.set_collision_mask_value(1,false)
	else :
		wallHit.play()
	if body.get_name() == "Bar":
		direction = (position - body.position).normalized()
		velocity = direction *  min(ball_speed, MAX_SPEED)
	linear_velocity = velocity

func _integrate_forces(state:PhysicsDirectBodyState2D):
	if mode ==0:
		state.transform.origin = Vector2(paddle.position.x, 500)
		if Input.is_action_just_pressed("launch_ball"):
			mode = 1
			# ボールが発射される向きを初期化し定義する
			state.linear_velocity = Vector2.ZERO
			direction = Vector2(1, -1).normalized()
			velocity = direction * ball_speed
			state.apply_central_impulse(velocity)
	if mode ==2:
		state.transform.origin = Vector2(ballPosition)
		ball_speed = 430
		mode = 0

