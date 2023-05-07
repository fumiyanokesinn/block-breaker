extends Node

var levelNum = 1
var scoreCount = 0
var lifeCount = 3

const MAX_BAR = 28
const MAX_LIFE = 3

@onready var level = $Level1
@onready var nextScreen = $NextScreen
@onready var nextScreenLevel = $NextScreen/VBoxContainer/Level
@onready var nextScreenLife = $NextScreen/VBoxContainer/HBoxContainer/Life
@onready var nextScreenScore = $NextScreen/VBoxContainer/Score
@onready var hudLevel = $HUD/LeftBox/Level
@onready var hudScore = $HUD/LeftBox/Score
@onready var bar = $Bar
@onready var ball = $Ball
@onready var barPosition = bar.position
@onready var lifes = get_tree().get_nodes_in_group("Life")
@onready var blocks = get_tree().get_nodes_in_group("Blocks")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true

func set_next_level():
	get_tree().paused = true
	await get_tree().create_timer(1).timeout 
	print("set_next_level() start")
	levelNum += 1
	
	nextScreenLevel.text = "Level : %s" % levelNum
	nextScreen.show()
	
	hudLevel.text = "Level : %s" % levelNum
	
	bar.position = barPosition
	ball.mode = 2
	
	for block in blocks:
		block.show()
		block.set_collision_layer_value(1,true)
		block.set_collision_mask_value(1,true)

func _on_ball_body_entered(body):
	if body.is_in_group("Blocks"):
		scoreCount += 1
		hudScore.text = "Score : %s" % scoreCount
		nextScreenScore.text = "Score : %s" % scoreCount
		if scoreCount == levelNum * MAX_BAR:
			scoreCount = 0
			set_next_level()

func game_over():
	print("game_over() start")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://GameStartView.tscn")
	
	bar.position = barPosition
	ball.mode = 2
	
	levelNum = 0
	scoreCount = 0

func _on_area_2d_body_entered(body):
	if lifeCount == 1:
		game_over()
	else:
		reduce_life()

func reduce_life():
	print("reduce_life() start")
	lifeCount -= 1
	nextScreenLife.text = "x %s" % lifeCount
	var count = 0
	for life in lifes:
		count += 1
		if count <= lifeCount:
			life.show()
		else:
			life.hide()
	
	nextScreen.show()
	bar.position = barPosition
	ball.mode = 2
	
	get_tree().paused = true
