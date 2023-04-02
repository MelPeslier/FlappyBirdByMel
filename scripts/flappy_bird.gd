extends Node

@export var tube_entree_scene : PackedScene

@onready var timer_spawn_mob = $TubeEntreeTimer

var y_max_interval_position = 72

func _ready():
	connect("on_game_over",self,"game_over")
	game_start()

func game_start():
	timer_spawn_mob.start()

func game_over(bird):
	bird.alive = !bird._is_alive()
	timer_spawn_mob.stop()
	
	var nb_tubes = get_child_count()
	print(str(nb_tubes))

func _on_tube_entree_timer_timeout():
	var tube = tube_entree_scene.instantiate()

	var tube_spawn_location = $SpawnLocation
	
	var position = tube_spawn_location.position
	position.y += randf_range(-y_max_interval_position, y_max_interval_position)
	tube.position = position
	
	var direction = Vector2(1000,position.y)
	tube.look_at(direction)
	
	add_child(tube)

