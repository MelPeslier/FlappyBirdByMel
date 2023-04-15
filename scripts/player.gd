extends Area2D

# J'initialise des variables avec "export" pour pouvoir les modifier in-game dans 
# l'inspecteur
@export var _gravity = 2000
var _jump_force = 500
var _max_fall_speed = 800

var _velocity = Vector2.ZERO
var screen_size
var _animated_sprite
var alive = true

var _nb_bumps = 5

var is_boss = false
var animation : String = "flap"

func _get_input():
	# quand on presse la commande "flap_up" alors on donne une force vers le haut
	if Input.is_action_just_pressed("flap_up"):
		_velocity.y = -_jump_force
		_animated_sprite.play(animation)



func _ready():
	#connexion au signal boss mode pour passer le joueur en rouge
	Events.boss_mode.connect(_on_boss_mode);
	
	screen_size = get_viewport_rect().size
	
	_animated_sprite = $AnimatedSprite2D

func _on_boss_mode():
	is_boss = true
	animation = "flap_red"

func _die():
	if alive :
		alive = not alive
		Events.emit_signal("death")

func _process(delta):
	
	if alive:
		_get_input()
	
	if _nb_bumps > 0 :
		# rajout constant de vitesse vers le bas pour simuler la gravité sans jamais dépasser une certain seuil
		_velocity.y += _gravity * delta
		if _velocity.y > _max_fall_speed :
			_velocity.y = _max_fall_speed
	
		# actualisation de la position de notre joueur par rapport à sa direction / ses déplacements
		position += _velocity * delta
	
	if not alive or _velocity.y > 0 :
		_animated_sprite.pause()



