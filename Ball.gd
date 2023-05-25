extends RigidBody2D

@export var start_speed = 430
@export var MAX_SPEED = 600
@export var speed_up = 5
@export var ball_speed = 430
# 0:待機時　1:発射時 2:リセット時
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

func _physics_process(delta):
	# プレイヤーが移動しているときタイマーで設定した間隔で残像を出す
	if direction.length() > 0 and $GhostTimer.time_left == 0 and mode == 1 and ball_speed >= 800:
		instance_ghost() 

func _on_body_entered(body):
	ball_speed = min(ball_speed + speed_up, MAX_SPEED)
	direction = linear_velocity.normalized() # 追加
	velocity = direction * ball_speed
	
	# 硬いボール当たった時の挙動 (使用していない)
#	if body.is_in_group("BlockHards"):
#		blockHit.play()
#		body.modulate = Color(0,1,0)
#		print(body.get_meta('stock_hit'))
#		if body.get_meta('stock_hit') ==1:
#			body.queue_free()
#		body.set_meta('stock_hit', 1)
	
	# ボール当たった時の挙動
	if body.is_in_group("Blocks") && !body.is_in_group("BlockHards"):
		blockHit.play()
		body.hide()
		body.set_collision_layer_value(5,false)

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
		mode = 0

# 残像を出すための関数
func instance_ghost():
	# 残像シーンのインスタンスを子ノードに追加する
	var ghost_scene = preload("res://Ghost.tscn")
	var ghost = ghost_scene.instantiate()
	get_parent().add_child(ghost) 
	ghost.texture = $Sprite2D.texture
	# 残像がプレイヤーの居た位置に出るようにする
	ghost.global_position = global_position
	
	# タイマーを作動させる
	$GhostTimer.start()
