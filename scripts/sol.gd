extends Area2D


func _on_area_entered(area):
	
	if area._is_alive():
		area.alive = !area._is_alive()
	
	area._jump_force *= 0.85
	area._nb_bumps -= 1
	area._velocity.y = - area._jump_force
