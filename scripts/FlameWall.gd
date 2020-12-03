extends AnimatedSprite

export (int) var damage = 75

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('flamewalls')
	
func burn():
	show()
	$Area2D/CollisionShape2D.disabled = false
	$Lifetime.start()
	
func douse():
	hide()
	$Area2D/CollisionShape2D.disabled = true
	
func _on_Area2D_area_entered(area):
	var t = area.get_parent()
	if t.is_in_group('mobs'):
		play_burn_sound()
		hit_target(t)

func play_burn_sound():
	var player = AudioStreamPlayer.new()
	player.connect('finished', self, '_on_burn_sound_finished', [player])
	player.volume_db = -20
	add_child(player)
	player.stream = load('res://assets/sound/effects/Burn.wav')
	player.play()
	
func _on_burn_sound_finished(player):
	player.queue_free()

func _on_Lifetime_timeout():
	douse()
	
func add_resources():
	r.add_build(5)

func hit_target(target):
	var killed = target.hit(damage)
	if killed:
		target.queue_free()
		add_resources()
