extends Node

var levelNum = 1
var scoreCount = 0
var barCount = 1

@onready var level = $Level1
@onready var nextScreen = $NextScreen
@onready var nextScreenLevel = $NextScreen/VBoxContainer/Level
@onready var hudLevel = $HUD/LeftBox/Level
@onready var hudScore = $HUD/LeftBox/Score
@onready var bar = $Bar
@onready var ball = $Ball
@onready var barPosition = bar.position
@onready var ballPosition = ball.position

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	print(ballPosition)

func set_next_level():
	print("set_next_level() start")
	levelNum += 1
	
	nextScreenLevel.text = "Level : %s" % levelNum
	nextScreen.show()
	
	hudLevel.text = "Level : %s" % levelNum
	
	ball.freeze = true
	
	bar.position = barPosition
	ball.position = ballPosition
	
	ball.freeze = false
	
	get_tree().paused = true

func _on_ball_body_entered(body):
	if body.is_in_group("Blocks"):
		scoreCount += 1
		hudScore.text = "Score : %s" % scoreCount
		if scoreCount == levelNum * barCount:
			scoreCount = 0
			set_next_level()
