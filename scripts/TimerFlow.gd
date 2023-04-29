extends Timer

var time_scale: float = 1
var timer_wait_time: float = 1
var should_continue: bool = true

func _ready():
	Events.timer_alter_flow.connect(_start_timer_alter_flow)
	wait_time = timer_wait_time

func _start_timer_alter_flow(new_time_value: float, period_of_new_timer: float):
	
	var alter_time_timer = Timer.new()
	add_child(alter_time_timer)
	
	alter_time_timer.wait_time = period_of_new_timer
	alter_time_timer.one_shot = true
	alter_time_timer.timeout.connect(_reset_time_flow.bind(new_time_value))
	
	alter_time_flow(new_time_value)
	
	alter_time_timer.start()

func alter_time_flow(factor: float):

	GlobalTime.global_time = factor
	time_scale = factor
	var my_time_left = time_left
	stop()
	if my_time_left > 0 :
		wait_time = my_time_left * (1.0/time_scale)
	else :
		wait_time = 0.000001 * (1.0/time_scale)
	start()

func _reset_time_flow(the_right_time_scale):
	var my_time_left = time_left
	stop()
	wait_time = my_time_left * the_right_time_scale
	
	if time_scale == the_right_time_scale :
		GlobalTime.global_time = 1
		time_scale = 1
	else :
		GlobalTime.global_time = time_scale
	
	
	start()

func _on_timeout():
	stop()
	if should_continue :
		wait_time = timer_wait_time * (1.0/time_scale)
		Events.emit_signal("spawn_tube")
		start()
	else : 
		wait_time = timer_wait_time

