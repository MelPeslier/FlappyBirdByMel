extends Node2D

var speed = 180
var velocity = Vector2.ZERO


func _process(delta):
	velocity.x = -speed
	position += velocity * delta * GlobalTime.global_time
