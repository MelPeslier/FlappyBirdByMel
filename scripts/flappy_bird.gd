extends Node

@export var tube_entree_scene : PackedScene
@onready var timer_spawn_mob = $TubeEntreeTimer
@onready var tube_spawn_location = $SpawnLocation
@onready var start_position = $PlayerPosition
@onready var player = $Player

var y_max_interval_position = 112

func _ready():
	game_start()
	

func game_start():
	player.position = start_position.position
	
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
	timer_spawn_mob.stop()
	var tubes = tube_spawn_location.get_children()
	for i in tubes :
		i.set_process(false)
	
	
