extends Area2D

export (int) var speed = 200
var target_pos: Vector2

func _ready():
	pass
	
func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Spell_area_entered(area):
	var target = area.get_parent()
	if target.is_in_group("mobs"):
		$Projectile.animation = 'hit'
		speed = 0
		target.queue_free()

func _on_Projectile_animation_finished():
	if $Projectile.animation == 'hit':
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
