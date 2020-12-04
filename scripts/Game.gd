extends Node2D

onready var hp_bar = $UI/HP
onready var mana_bar = $UI/Mana
onready var build_bar = $UI/Build
onready var special_bar = $UI/Special
onready var score_label = $UI/Score

const ice_zombie = preload('res://scenes/IceZombie.tscn')
const zombie = preload('res://scenes/Zombie.tscn')
const big_zombie = preload('res://scenes/BigZombie.tscn')
const boss_orc = preload('res://scenes/BossOrc.tscn')

var enemy_pool = [ice_zombie, zombie, big_zombie]

const fireball = preload('res://scenes/FireBall.tscn')

var can_special = false
var shield_on = false

var boss_countdown = 0

func _ready():
	r.connect('special_update', self, '_on_special_update')
	r.connect('hp_update', self, '_on_hp_update')
	
	r.hp_bar = hp_bar
	r.mana_bar = mana_bar
	r.build_bar = build_bar
	r.special_bar = special_bar
	r.score_label = score_label
	r.add_hp(100)
	r.add_mana(100)
	
func _physics_process(delta):
	# Where the spells are directed
	$Map/TowerCast.look_at(get_global_mouse_position())
	
func _input(event):
	if event.is_action_pressed('left_click') or event.is_action_pressed('fireball') and not g.cursor_busy:
		cast_fireball()
	if event.is_action_pressed('special') and not $UI/SpecialButton.disabled:
		$UI/SpecialButton.emit_signal("button_up")
	if event.is_action_pressed("shield") and not $UI/ShieldButton.disabled:
		$UI/ShieldButton.emit_signal("button_up")
	if event.is_action_pressed("lightning") and not $UI/LightingButton.disabled:
		$UI/LightingButton.emit_signal("button_up")
		
func _on_special_update(new_special_value):
	can_special = new_special_value == 100
	$UI/SpecialButton.disabled = !can_special
	
func _on_hp_update(new_hp_value):
	if new_hp_value == 0:
		get_tree().paused = true
		$UI/GameOver.show()

func spawn_enemy(point):
	var new_enemy = enemy_pool[randi() % 3].instance()
	new_enemy.nav = $Map
	new_enemy.start_num = point
	new_enemy.position = get_node("Map/EnemyStart"+str(point)).position
	$Map/YSort.add_child(new_enemy)

func cast_fireball():
	var f = fireball.instance()
	if(r.mana > f.cost):
		r.subtract_mana(f.cost)
		$Map.add_child(f)
		f.transform = $Map/TowerCast.transform
	else:
		f.queue_free()

func _on_SpawnTimer_timeout():
	var n = randi() % 6 + 1
	spawn_enemy(n)

func _on_DifficultyTimer_timeout():
	boss_countdown += 1
	if boss_countdown == 3:
		spawn_boss()
	if str($SpawnTimer.wait_time) > '0.1':
		$SpawnTimer.wait_time -= 0.1
	
func spawn_boss():
	var new_boss = boss_orc.instance()
	new_boss.nav = $Map
	new_boss.start_num = 2
	new_boss.position = get_node("Map/EnemyStart2").position
	$Map/YSort.add_child(new_boss)

func _on_ManaRegen_timeout():
	r.add_mana(1)

func _on_HealthRegen_timeout():
	r.add_hp(1)

func _on_SpecialButton_button_up():
	if r.special >= 100:
		r.subtract_special(100)
		var flamewalls = get_tree().get_nodes_in_group('flamewalls')
		for flamewall in flamewalls:
			flamewall.burn()

func _on_LightingButton_button_up():
	var lighting = get_tree().get_nodes_in_group('lighting')
	if r.mana >= lighting[0].cost:
		r.subtract_mana(lighting[0].cost)
		for l in lighting:
			l.cast()
