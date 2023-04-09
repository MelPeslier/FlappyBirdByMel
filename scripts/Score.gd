extends Label
var score = 0
var high_score = 0

func _ready():
	Events.add_point.connect(_on_add_point)
	_set_affichage()

func _on_add_point():
	score += 1
	_set_affichage()

func _reset_score():
	if score > high_score :
		_new_high_score(score)
	score = 0

func _new_high_score(s):
	# play an animation that print the new high score !
	high_score = s
	print ("High score : %s" % high_score)

func _set_affichage():
	text = "%s" % score
