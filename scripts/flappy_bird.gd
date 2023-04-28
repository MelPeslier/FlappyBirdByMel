extends Node

@onready var reset_sound = $UILayer/HUD/ResetSound

@onready var tube_entree_scene : PackedScene = preload("res://scenes/tube_entree.tscn")
@onready var timer_spawn_mob = $TubeEntreeTimer
@onready var flash_timer = $FlashTimer
@onready var tube_spawn_location = $SpawnLocation
@onready var start_position = $PlayerPosition
@onready var hud = $UILayer/HUD
#Pour stocker le maeriel du gray scale rectangle
@onready var g = $AllFlashCanvas/BackBufferCopy/GrayscaleRect.material
#Pour stocker le materiel du Flash rect
@onready var f = $AllFlashCanvas/BackBufferCopy2/FlashRect.material

@onready var player_scene : PackedScene = preload("res://scenes/player.tscn")

@onready var player = player_scene.instantiate()

@onready var start_button = hud.find_child("Start Button")
@onready var game_over_message = hud.find_child("GameOverMessage")
var position_depart_y_message_over = -30

var y_max_interval_position = 112

var y_screen: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var x_screen: int = ProjectSettings.get_setting("display/window/size/viewport_width")

var t: Tween
var t2: Tween

# Pour les flashs
var one_third_time : float = 0.333
var instant_time : float = 0.0001

var boss_color : Color = Color.hex(0xce002adb)
var white : Color = Color.hex(0xffffffff)

var imin : float = 1.5
var imax : float = 3.0
var rand_time : float



func _ready() -> void:
	Events.boss_mode.connect(_on_boss_mode)
	Events.death.connect(_on_player_death)
	Events.bounce.connect(_on_bounce)
	
	player.position = start_position.position
	add_child(player)
	
	start_button.pressed.connect(_button_play_pressed)
	
	player.set_process(false)
	
	_pre_start()

func _on_boss_mode():
	on_gray_canvas_animation("boss_mode")

func _button_play_pressed():
	start_button.find_child("AnimationPlayer").play("disappear")
	game_start()

func _pre_start():
	var score = $UILayer/Score
	score._reset_score()
	score._set_affichage()
	
	reset_sound.play()
	start_button.find_child("AnimationPlayer").play("appear")
	
	var tubes = tube_spawn_location.get_children()
	for i in tubes :
		i.queue_free()
	
	t = create_tween()
	t.tween_property(player, "position", start_position.position, 0.6)
	
	player.set_process(false)

func _restart():
	game_over_message.find_child("AnimationPlayer").play("disappear")
	on_gray_canvas_animation("RESET", 0.0)
	_pre_start()

func game_start():
	#player
	player._reset_player()
	player.set_process(true)
	
	#First move
	player.flap_sound.play()
	player._velocity.y = - player._jump_force
	player._animated_sprite.play(player.animation)
	
	#tuyaux
	timer_spawn_mob.start()


func _on_tube_entree_timer_timeout():
	var tube = tube_entree_scene.instantiate()
	
	var position = Vector2(0,0)
	position.y += randf_range(-y_max_interval_position, y_max_interval_position)
	tube.position = position
	
	var direction = Vector2(1000,position.y)
	tube.look_at(direction)
	
	tube_spawn_location.add_child(tube)

func _on_player_death():
	#animations
	player.find_child("AnimationPlayer").play("flash")
	
	timer_spawn_mob.stop()
	var tubes = tube_spawn_location.get_children()
	for i in tubes :
		i.set_process(false)
		t = create_tween()
		t.tween_interval(0.3)
		
		if i.position.x > -248 :
			t.tween_property(i, "position:x", 0., 0.3)
		else:
			t.tween_property(i, "position:x", -400., 0.3)
	
	game_over_message.find_child("AnimationPlayer").play("appear")
	
	var restart_timer = Timer.new()
	add_child(restart_timer)
	restart_timer.wait_time = 2
	restart_timer.one_shot = true
	restart_timer.timeout.connect(_restart)
	restart_timer.start()

func on_gray_canvas_animation(value : String, next_step : float = 1.0 ):
	t = create_tween()
	match value:
		"boss_mode":
			t.tween_property(
				g,
				"shader_parameter/scale_of_gray", 
				next_step, 
				one_third_time
			)
			t.parallel().tween_property(
				g,
				"shader_parameter/color", 
				boss_color,
				one_third_time
			)
			on_boss_mode_flash(true)
			
		"dead_mode":
			t.tween_property(
				g,
				"shader_parameter/scale_of_gray", 
				next_step, 
				instant_time
			)
			t.parallel().tween_property(
				g,
				"shader_parameter/color", 
				white,
				instant_time
			)
			on_boss_mode_flash(false)
			
		"RESET":
			t.tween_property(
				g,
				"shader_parameter/scale_of_gray", 
				next_step,
				one_third_time
			)
			t.parallel().tween_property(
				g,
				"shader_parameter/color", 
				white,
				one_third_time
			)
			on_boss_mode_flash(false)
			

func on_boss_mode_flash(value : bool):
	if value :
		rand_time = randf_range(imin, imax)
		flash_timer.start(rand_time)
	else :
		flash_timer.stop()


func _on_flash_timer_timeout():
	t = create_tween()
	t.tween_property(
		f, 
		"shader_parameter/flashState", 
		1.0,
		rand_time/randf_range(imin, imax)
	)
	t.tween_property(
		f, 
		"shader_parameter/flashState", 
		0.0,
		rand_time/randf_range(imin, imax)
	)
	flash_timer.start(randf_range(2., 3.))

# Calcul l'intensité de gris au prochain rebond.
func _on_bounce(max_bumps, new_step):
	var next_step = (max_bumps - new_step) / max_bumps
	on_gray_canvas_animation("dead_mode", next_step)



