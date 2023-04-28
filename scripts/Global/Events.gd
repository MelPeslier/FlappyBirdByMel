extends Node

# Utilisation de la fonctionnalité "autoload"

# Donc ce qui sera définit ici sera chargé en global
signal death()

signal bounce(max_bumps : float, new_step : float)

signal add_point()

signal boss_mode()

signal spawn_tube()

signal access_timer_alter(mode: String ,new_time_value: float)
