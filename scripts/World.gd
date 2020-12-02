extends Node2D

const zombie = preload('res://scenes/IceZombie.tscn')
const fireball = preload('res://scenes/FireBall.tscn')

func _ready():
	spawn_enemy()
	
func _physics_process(delta):
	# Where the spells are directed
	$Map/TowerCast.look_at(get_global_mouse_position())
	
func _input(event):
	if event.is_action_pressed('left_click'):
		cast_fireball()

func spawn_enemy():
	var new_enemy = zombie.instance()
	new_enemy.position = $Map/EnemyStart.position
	$Map.add_child(new_enemy)

func cast_fireball():
	var f = fireball.instance()
	$Map.add_child(f)
	f.transform = $Map/TowerCast.transform
