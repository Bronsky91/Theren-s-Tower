extends Area2D

export var speed = 200
export var steer_force = 70.0
export (int) var damage = 50

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
	speed = 0
	$CollisionShape2D.call_deferred('set_disabled', true)
	$AnimatedSprite.play()
	yield($AnimatedSprite, "animation_finished")
	queue_free()

func _on_Midas_area_entered(area):
	var t = area.get_parent()
	if t.is_in_group('mobs'):
		hit_target(t)
		explode()

func add_resources():
	r.add_special(1)
	r.add_score(1)

func hit_target(target):
	var killed = target.hit(damage)
	if killed:
		target.queue_free()
		add_resources()
