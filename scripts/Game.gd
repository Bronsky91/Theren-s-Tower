extends Node2D

const ice_zombie = preload('res://scenes/IceZombie.tscn')
const zombie = preload('res://scenes/Zombie.tscn')
const big_zombie = preload('res://scenes/BigZombie.tscn')

var enemy_pool = [ice_zombie, zombie, big_zombie]

const fireball = preload('res://scenes/FireBall.tscn')

func _ready():
	pass
	
func _physics_process(delta):
	# Where the spells are directed
	$Map/TowerCast.look_at(get_global_mouse_position())
	
func _input(event):
	if event.is_action_pressed('left_click') and not g.cursor_busy:
		cast_fireball()

func spawn_enemy(point):
	var new_enemy = enemy_pool[randi() % 3].instance()
	new_enemy.nav = $Map
	new_enemy.start_num = point
	new_enemy.position = get_node("Map/EnemyStart"+str(point)).position
	$Map/YSort.add_child(new_enemy)

func cast_fireball():
	var f = fireball.instance()
	$Map.add_child(f)
	f.transform = $Map/TowerCast.transform

func _on_SpawnTimer_timeout():
	var n = randi() % (6 - 1) + 1
	spawn_enemy(n)
