extends Area2D

@onready var flap_sound = $FlapSound
@onready var hit_sound = $HitSound
@onready var die_sound = $DieSound
# J'initialise des variables avec "export" pour pouvoir les modifier 
# in-game dans l'inspecteur
var _gravity = 2000
var _normal_jump_force = 500
var _jump_force = _normal_jump_force
var _max_fall_speed = 800

var _velocity = Vector2.ZERO
var screen_size
var _animated_sprite
var alive = true

var max_nb_bumps : float = 3
var _nb_bumps : float = max_nb_bumps

var is_boss = false
var animation : String = "flap"
var normal_pitch_scale : float = 1
var boss_pitch_scale : float = 0.66
var actual_pitch_scale : float = normal_pitch_scale

func _get_input():
	# quand on presse la commande "flap_up" alors on donne une force vers le haut
	if Input.is_action_just_pressed("flap_up"):
		flap_sound.play()
		_velocity.y = -_jump_force
		_animated_sprite.play(animation)

func _reset_player():
	#Sons
	actual_pitch_scale = normal_pitch_scale
	flap_sound.pitch_scale = actual_pitch_scale
	hit_sound.pitch_scale = actual_pitch_scale
	die_sound.pitch_scale = actual_pitch_scale
	
	#Animations
	animation = "flap"
	
	#Variables
	is_boss = false
	alive = true
	_nb_bumps = max_nb_bumps
	_jump_force = _normal_jump_force
	
	

func _ready():
	#connexion au signal boss mode pour passer le joueur en rouge
	Events.boss_mode.connect(_on_boss_mode);
	
	screen_size = get_viewport_rect().size
	
	_animated_sprite = $AnimatedSprite2D

func _on_boss_mode():
	#joueur
	is_boss = true
	animation = "flap_red"
	_animated_sprite.play(animation)
	_animated_sprite.stop()
	
	#Son
	actual_pitch_scale = boss_pitch_scale
	flap_sound.pitch_scale = actual_pitch_scale
	hit_sound.pitch_scale = actual_pitch_scale
	die_sound.pitch_scale = actual_pitch_scale

func _die():
	if alive :
		hit_sound.play()
		die_sound.play()
		alive = not alive
		_jump_force *= 1.3
		Events.emit_signal("death")


func _process(delta):
	
	if alive:
		_get_input()
	
	if _nb_bumps > 0 :
		# rajout constant de vitesse vers le bas pour simuler la gravité sans 
		# jamais dépasser une certain seuil
		_velocity.y += _gravity * delta
		if _velocity.y > _max_fall_speed :
			_velocity.y = _max_fall_speed
	
		# actualisation de la position de notre joueur par rapport à sa 
		# direction / ses déplacements
		position += _velocity * delta * GlobalTime.global_time
	
	if not alive or _velocity.y > 0 :
		_animated_sprite.pause()



