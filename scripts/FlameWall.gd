extends AnimatedSprite

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
		t.queue_free()

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
