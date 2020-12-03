extends AnimatedSprite

onready var game = get_node('/root/Game')
onready var button = get_node('/root/Game/UI/LightingButton')

export (int) var cost = 20
export (int) var damage = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('lighting')

func cast():
	button.disabled = true
	show()
	play()

func done():
	button.disabled = false
	hide()
	stop()

func hit_target(target):
	var killed = target.hit(damage)
	if killed:
		target.queue_free()
		add_resources()
		
func add_resources():
	r.add_build(5)
	r.add_special(1)
	r.add_score(1)

func _on_Lighting_animation_finished():
	var areas = $Area2D.get_overlapping_areas()
	for area in areas:
		var t = area.get_parent()
		if t.is_in_group('mobs'):
			hit_target(t)
	done()
