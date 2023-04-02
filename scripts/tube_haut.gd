extends Area2D


func _on_area_entered(area):
	if area._is_alive():
		area.alive = !area._is_alive()

