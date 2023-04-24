extends Area2D

func _on_area_entered(area):
	
	area._die()
	
	area._jump_force *= 0.9
	area._nb_bumps -= 1
	area._velocity.y = - area._jump_force
	
	Events.emit_signal("bounce", area.max_nb_bumps, area._nb_bumps)
