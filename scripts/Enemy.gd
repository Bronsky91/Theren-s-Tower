extends AnimatedSprite

var speed = 50
var path : = PoolVector2Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('mobs')
	var nav: Navigation2D = get_parent()
	var start: Vector2 = nav.get_node('EnemyStart').position
	var end: Vector2 = nav.get_node('TowerRight').position
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

