extends Area2D

export (int) var speed = 200
export (int) var damage = 30
export (int) var cost = 5

var target_pos: Vector2

func _ready():
	play_fireball_sound()
	
func _physics_process(delta):
	position += transform.x * speed * delta

func _on_FireBall_area_entered(area):
	var target = area.get_parent()
	if target.is_in_group("mobs"):
		hit_target(target)
		speed = 0
		$Projectile.animation = 'hit'
		$CollisionShape2D.call_deferred('set_disabled', true)
		play_explode_sound()
		
func hit_target(target):
	var killed = target.hit(damage)
	if killed:
		target.queue_free()
		add_resources()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func play_fireball_sound():
	var n = randi() % 4
	var whooshes = ['A', 'B', 'C', 'D']
	var player = $AudioStreamPlayer
	player.stream = load('res://assets/sound/effects/FB_Passby_Whoosh_'+whooshes[n]+'.wav')
	player.play()

func play_explode_sound():
	var player = $AudioStreamPlayer
	player.stream = load('res://assets/sound/effects/Burn.wav')
	player.play()

func _on_AudioStreamPlayer_finished():
	if speed == 0:
		queue_free()

func _on_Projectile_animation_finished():
	if $Projectile.animation == 'hit':
		$Projectile.stop()
		$Projectile.hide()
		
func add_resources():
	r.add_build(5)
	r.add_special(1)
