extends CharacterBody2D

var speed = 700
var direction = Vector2()
var collision_shape
# barのxサイズの半分を取得
var barWidth

# Called when the node enters the scene tree for the first time.
func _ready():
	barWidth = $Sprite2D.texture.get_width() * $Sprite2D.scale.x / 2
	collision_shape = $CollisionShape2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input() # キーの入力を判定する
	position += direction * delta  # 位置を更新
	position.x = clamp(position.x, 0 + barWidth, get_viewport_rect().size.x - barWidth)  # 位置を画面内に制

# 右か左のキーを押していたら左右に移動する
func get_input():
	direction = Vector2()
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if direction.length() > 0:
		direction = direction.normalized() * speed
