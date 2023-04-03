extends Node

@export var tube_entree_scene : PackedScene
@onready var timer_spawn_mob = $TubeEntreeTimer
@onready var tube_spawn_location = $SpawnLocation
@onready var start_position = $PlayerPosition
@onready var start_button_scene = preload("res://scenes/start_button.tscn")
@onready var game_over_scene = preload("res://scenes/game_over_message.tscn")
@onready var player_scene = preload("res://scenes/player.tscn")

var y_max_interval_position = 112

@onready var player = player_scene.instantiate()
@onready var start_button = start_button_scene.instantiate()

@onready var game_over_message = game_over_scene.instantiate()

var y_screen: int = ProjectSettings.get_setting("display/window/size/viewport_height")

var x_screen: int = ProjectSettings.get_setting("display/window/size/viewport_width")

var t: Tween

var position_depart_y_message_over = -30

func _ready() -> void:
	Events.death.connect(_on_player_death)
	
	player.position = start_position.position
	add_child(player)
	
	start_button.position = Vector2(0,0)
	start_button.pressed.connect(game_start)
	
	player.set_process(false)
	add_child(start_button)
	
	game_over_message.position = Vector2(x_screen/2., position_depart_y_message_over)
	add_child(game_over_message)

func _pre_start():
	player.alive = true
	player._nb_bumps = 5
	player._jump_force = 400
	var tubes = tube_spawn_location.get_children()
	for i in tubes :
		i.queue_free()
	
	player.set_process(false)
	player.position = start_position.position


func game_start():
	start_button.disabled = true
	player.set_process(true)
	timer_spawn_mob.start()
	player._velocity.y = - player._jump_force
	player._animated_sprite.play("flap")
	t = create_tween()
	t.tween_property(start_button, "visible", false, 0.3)
	#utiliser un callable "voir video youtube" pour creer un mouvement de va et vien sur le bouton !

func _on_tube_entree_timer_timeout():
	var tube = tube_entree_scene.instantiate()
	
	var position = Vector2(0,0)
	position.y += randf_range(-y_max_interval_position, y_max_interval_position)
	tube.position = position
	
	var direction = Vector2(1000,position.y)
	tube.look_at(direction)
	
	tube_spawn_location.add_child(tube)

func _on_player_death():
	timer_spawn_mob.stop()
	var tubes = tube_spawn_location.get_children()
	for i in tubes :
		i.set_process(false)
	
	t = create_tween()
	t.tween_property(game_over_message, "position:y", y_screen/4., 1)
	t.tween_interval(1)
	t.tween_property(game_over_message, "position:y", position_depart_y_message_over, 1)
	t.tween_property(start_button, "visible", true, 0.3)
	start_button.disabled = false
	var restart_timer = Timer.new()
	add_child(restart_timer)
	restart_timer.wait_time = 3
	restart_timer.one_shot = true
	restart_timer.timeout.connect(_pre_start)
	restart_timer.start()


