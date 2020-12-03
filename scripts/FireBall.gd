extends Area2D

export (int) var speed = 200
var target_pos: Vector2

func _ready():
	play_fireball_sound()
	
func _physics_process(delta):
	position += transform.x * speed * delta

func _on_FireBall_area_entered(area):
	var target = area.get_parent()
	if target.is_in_group("mobs"):
		add_resources()
		play_explode_sound()
		$Projectile.animation = 'hit'
		speed = 0
		target.queue_free()
		
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
