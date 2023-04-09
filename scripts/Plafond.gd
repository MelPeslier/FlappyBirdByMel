extends Area2D


func _on_area_entered(area):
	area._velocity.y = area._jump_force
