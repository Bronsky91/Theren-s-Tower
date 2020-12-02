extends Area2D

const midas = preload('res://scenes/Midas.tscn')

export var cooldown = 1

var target = null
var can_cast = true
var hover = false
var can_build = false

# Called when the node enters the scene tree for the first time.
func _ready():
	r.connect('build_update', self, '_on_build_update')
	
func _on_build_update(new_build_value):
	can_build = new_build_value == 100
	$Build/Hammer.visible = can_build
	
func _physics_process(delta):
	if !target and $Built.visible:
		find_target()
	if target:
		cast_midas()

func _input(event):
	if event.is_action_pressed('left_click') and hover and can_build:
		build_tower()
		
func cast_midas():
	if can_cast:
		var m = midas.instance()
		get_parent().add_child(m)
		m.start($Built/CastPosition.global_transform, target)
		can_cast = false
		yield(get_tree().create_timer(cooldown), "timeout")
		can_cast = true
		
func find_target():
	var areas = $Range.get_overlapping_areas()
	var units = []
	for area in areas:
		var t = area.get_parent()
		if t.is_in_group('mobs'):
			units.append(t)
	if units.size() > 0:
		var closest = units[0]
		for unit in units:
			if position.distance_to(unit.global_position) < position.distance_to(closest.global_position):
				closest = unit
		target = closest
	else:
		target = null

func build_tower():
	$Build.hide()
	build_animation()
	r.subtract_build(100)
	
func build_animation():
	$Building.show()
	$Building.play()
	
func _on_FireTower_mouse_entered():
	g.set_cursor_busy(true)
	hover = true
	

func _on_FireTower_mouse_exited():
	g.set_cursor_busy(false)
	hover = false

func _on_Building_animation_finished():
	# Finished Building
	$Building.stop()
	$Building.hide()
	$Built.show()

func _on_Range_area_exited(area):
	if area.get_parent() == target:
		target = null
