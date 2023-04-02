extends Area2D



func _on_area_entered(area):
	if area._is_alive():
		area._jump_force *= 1.5
		area._nb_bumps += 1
		area.alive = !area._is_alive()
