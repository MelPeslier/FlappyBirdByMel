extends Timer

var slow_factor: float = 1
var timer_wait_time: float = 1

func alter_flow(factor: float):
	slow_factor = factor
	var my_time_left = time_left
	stop()
	wait_time = my_time_left * (1.0/slow_factor)
	start()

func _on_timeout():
	stop()
	if slow_factor != 1.0:
		wait_time = timer_wait_time * (1.0/slow_factor)
	else:
		wait_time = timer_wait_time
	start()
	Events.emit_signal("spawn_tube")
