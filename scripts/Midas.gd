extends Area2D

export var speed = 200
export var steer_force = 70.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func start(_transform, _target):
	global_transform = _transform
	rotation_degrees = 270
	velocity = transform.x * speed
	target = _target
	
func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer
	
func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation_degrees = 0
	position += velocity * delta
	
func _on_Lifetime_timeout():
	explode()

func explode():
	set_physics_process(false)
	velocity = Vector2.ZERO
	$AnimatedSprite.play()
	yield($AnimatedSprite, "animation_finished")
	queue_free()
	

func _on_Midas_area_entered(area):
	var t = area.get_parent()
	if t.is_in_group('mobs'):
		t.queue_free()
		explode()
