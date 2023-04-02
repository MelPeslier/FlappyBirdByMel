extends Area2D

@onready var game = $Game

func _on_area_entered(area):
	if area._is_alive():
		game.game_over(area)

