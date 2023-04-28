extends Timer

var slow_factor: float = 1.0
var old_slow_factor: float = slow_factor
var timer_wait_time: float = 1

func slow_down(do_it: bool, factor: float):
	slow_factor = factor
	var my_time_left = time_left
	stop()
	if do_it:
		wait_time = my_time_left * (1.0/slow_factor)
	else:
		wait_time = my_time_left * (old_slow_factor)
		print(wait_time)
	old_slow_factor = slow_factor
	start()

func _on_timeout():
	Events.emit_signal("spawn_tube")
	stop()
	if slow_factor != 1.0:
		wait_time = timer_wait_time * (1.0/slow_factor)
	else:
		wait_time = timer_wait_time
	start()
