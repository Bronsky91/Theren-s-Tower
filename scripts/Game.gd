extends Node2D

onready var hp_bar = $UI/HP
onready var mana_bar = $UI/Mana
onready var build_bar = $UI/Build
onready var special_bar = $UI/Special

const ice_zombie = preload('res://scenes/IceZombie.tscn')
const zombie = preload('res://scenes/Zombie.tscn')
const big_zombie = preload('res://scenes/BigZombie.tscn')

var enemy_pool = [ice_zombie, zombie, big_zombie]

const fireball = preload('res://scenes/FireBall.tscn')

var can_special = false

func _ready():
	r.connect('special_update', self, '_on_special_update')
	
	r.hp_bar = hp_bar
	r.mana_bar = mana_bar
	r.build_bar = build_bar
	r.special_bar = special_bar
	r.add_hp(100)
	r.add_mana(100)
	
func _physics_process(delta):
	# Where the spells are directed
	$Map/TowerCast.look_at(get_global_mouse_position())
	
func _input(event):
	if event.is_action_pressed('left_click') and not g.cursor_busy:
		cast_fireball()
		
func _on_special_update(new_special_value):
	can_special = new_special_value == 100
	$UI/SpecialButton.disabled = !can_special

func spawn_enemy(point):
	var new_enemy = enemy_pool[randi() % 3].instance()
	new_enemy.nav = $Map
	new_enemy.start_num = point
	new_enemy.position = get_node("Map/EnemyStart"+str(point)).position
	$Map/YSort.add_child(new_enemy)

func cast_fireball():
	if(r.mana > 10):
		r.subtract_mana(10)
		var f = fireball.instance()
		$Map.add_child(f)
		f.transform = $Map/TowerCast.transform

func _on_SpawnTimer_timeout():
	var n = randi() % 6 + 1
	spawn_enemy(n)

func _on_DifficultyTimer_timeout():
	print($SpawnTimer.wait_time)
	if str($SpawnTimer.wait_time) > '0.1':
		$SpawnTimer.wait_time -= 0.1

func _on_ManaRegen_timeout():
	r.add_mana(1)

func _on_HealthRegen_timeout():
	r.add_hp(1)

func _on_SpecialButton_button_up():
	r.subtract_special(100)
	var flamewalls = get_tree().get_nodes_in_group('flamewalls')
	for flamewall in flamewalls:
		flamewall.burn()

