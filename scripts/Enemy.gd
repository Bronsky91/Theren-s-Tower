extends AnimatedSprite

export (int) var speed
export (int) var health
export (int) var power

var path : = PoolVector2Array()
var start_num: int
var nav: Navigation2D

var end_points = ['Right', 'Left']

var attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('mobs')
	var start: Vector2 = nav.get_node('EnemyStart'+str(start_num)).position
	var end: Vector2 = nav.get_node('Tower' + end_points[randi() % (2)]).position
	path = nav.get_simple_path(start, end)

func _process(delta):
	# Calculate the movement distance for this frame
	var distance_to_walk = speed * delta
	
	# Move the enemy along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The enemy does not have enough movement left to get to the next point.
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			# The enemy get to the next point
			position = path[0]
			path.remove(0)
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point
	
	if path.size() == 0 and not attacking:
		attacking = true
		start_attack()

func start_attack():
	var attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.connect('timeout', self, '_on_attack_timer_timeout')
	attack_timer.wait_time = 1
	attack_timer.start()

func attack():
	if not get_node("/root/Game").shield_on:
		r.subtract_hp(power)

func _on_attack_timer_timeout():
	attack()
	
func hit(amount):
	health -= amount
	# Return if killed or not
	return health <= 0


func _on_BossOrc_tree_exiting():
	r.add_score(1000)
