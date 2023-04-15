extends Area2D



func _on_area_entered(_area):
	Events.emit_signal("add_point")
	self.queue_free()
