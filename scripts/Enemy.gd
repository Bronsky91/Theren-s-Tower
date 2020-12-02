extends AnimatedSprite

export (int) var speed
export (int) var health

var path : = PoolVector2Array()
var start_num: int
var nav: Navigation2D

var end_points = ['Right', 'Left']

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("tree_exiting", self, '_on_Enemy_tree_exiting')
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

func _on_Enemy_tree_exiting():
	r.add_build(5)
	r.add_special(1)
