extends AnimatedSprite

onready var game = get_node('/root/Game')
onready var button = get_node('/root/Game/UI/ShieldButton')

export (int) var cost = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_ShieldButton_button_up():
	if r.mana >= cost:
		r.subtract_mana(cost)
		game.shield_on = true
		show()
		play()
		$ShieldTimer.start()
		button.disabled = true

func _on_ShieldTimer_timeout():
	hide()
	stop()
	button.disabled = false
	game.shield_on = false
