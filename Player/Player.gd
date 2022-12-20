class_name Player
extends Actor

const GRAVITY = 100.0
const WALK_SPEED = 200
const Jump_speed = 4

var velocity = Vector2()
var is_on_floor = 0
onready var _animation_player = $AnimationPlayer

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	if $RayCast2D.is_colliding():
		is_on_floor = 1

	if Input.is_action_pressed("move_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0

	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.


	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))

func _process(_delta):#(Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"))
	if  Input.is_action_pressed("move_right"):
		$Sprite.flip_h = false
		_animation_player.play("Run")
	elif Input.is_action_pressed("move_left"):
		$Sprite.flip_h = true
		_animation_player.play("Run")
	elif is_on_floor == 1:
		_animation_player.play("Idle")
