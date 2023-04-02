extends Area2D

@onready var game = $Game

func _on_area_entered(area):
	if area._is_alive():
		area._jump_force *= 1.5
		area._nb_bumps += 1
		game.game_over(area)
