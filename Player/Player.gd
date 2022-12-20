class_name Player
extends Actor

const GRAVITY = 200.0
const WALK_SPEED = 200
const Jump_speed = 4

var velocity = Vector2()
var is_on_floor = 0
onready var _animation_player = $AnimationPlayer

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	if $RayCast2D.is_colliding():
		is_on_floor = 1

	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0

	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.


	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))

func _process(_delta):
	if Input.is_action_pressed("ui_right"):
		_animation_player.play("walk")
	elif is_on_floor == 1:
		_animation_player.play("Idle")
