extends Node

@export var tube_entree_scene : PackedScene
@onready var timer_spawn_mob = $TubeEntreeTimer
@onready var tube_spawn_location = $SpawnLocation
@onready var start_position = $PlayerPosition
@onready var start_button_scene = preload("res://scenes/start_button.tscn")

@onready var player_scene = preload("res://scenes/player.tscn")

var y_max_interval_position = 112

@onready var player = player_scene.instantiate()
@onready var start_button = start_button_scene.instantiate()

func _ready() -> void:
	Events.death.connect(_on_player_death)
	
	player.position = start_position.position
	add_child(player)
	
	start_button.position = start_position.position
	start_button.pressed.connect(game_start)
	
	player.set_process(false)
	add_child(start_button)

func _pre_start():
	
	var tubes = tube_spawn_location.get_children()
	for i in tubes :
		i.queue_free()
	
	player.set_process(false)
	player.position = start_position.position


func game_start():
	player.set_process(true)
	timer_spawn_mob.start()
	#start_button.
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
	print("yes")
	var tubes = tube_spawn_location.get_children()
	for i in tubes :
		i.set_process(false)
	
	var restart_timer = Timer.new()
	add_child(restart_timer)
	restart_timer.wait_time = 3
	restart_timer.one_shot = true
	restart_timer.timeout.connect(_pre_start)
	restart_timer.start()


