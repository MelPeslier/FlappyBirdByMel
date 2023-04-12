extends Label

@onready var high_one = $HighScore
@onready var score_label_settings = preload("res://settings/score_label_settings.tres")
@onready var high_score_label_settings = preload("res://settings/high_score_label_settings.tres")

var score :int = 0
var high_score :int = 0
var boss :bool = false

func _ready():
	Events.add_point.connect(_on_add_point)
	_set_affichage()

func _on_add_point():
	score += 1
	if !boss && (score > high_score) :
		boss = true
		_change_label_settings()
		Events.emit_signal("boss_mode")
	_set_affichage()

func _reset_score():
	if score > high_score :
		_new_high_score()
	score = 0
	boss = false
	_change_label_settings()

func _new_high_score():
	# play an animation that print the new high score !
	high_score = score

func _set_affichage():
	text = "%s" % score
	high_one.text = "%s" % high_score

func _change_label_settings():
	if boss :
		self.set_label_settings(high_score_label_settings)
		high_one.set_label_settings(score_label_settings)
	else :
		self.set_label_settings(score_label_settings)
		high_one.set_label_settings(high_score_label_settings)
