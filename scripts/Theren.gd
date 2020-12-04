extends KinematicBody2D

onready var sprite = $Sprite

export (int) var speed
export (int) var health

var velocity = Vector2()

signal running

func _ready():
	connect('running', self, '_on_running_update')

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)


func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		sprite.flip_h = false
		velocity.x += 1
	if Input.is_action_pressed('left'):
		sprite.flip_h = true
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	sprite.play('run')
	
	if Input.is_action_just_released("up") or Input.is_action_just_released("down") or Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		sprite.play('idle')

