class_name Player
extends Actor


const MAXFALLSPEED = 200
const MAXSPEED = 80
const JUMPFORCE = 300
const GRAVITY = 

var state_machine
var attacks = ["Sword Slash","Sword Slash Down"]
var is_on_floor = 0
var velocity = Vector2.ZERO
var sworddrawn = false

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	

	
#region 
#func get_input():
#
#	var current = state_machine.get_current_node()
#	velocity = Vector2.ZERO
#
#	if Input.is_action_just_pressed("Light Attack") && (current == "idle-2" || current == "walk 2"):
#		state_machine.travel("Sword Slash")
#		return
#
#	if Input.is_action_just_pressed("Light Attack") && current == "idle":
#		state_machine.travel("punch")
#		return
#
#	if Input.is_action_just_pressed("Light Attack") && current == "walk":
#		state_machine.travel("run-punch")
#		return
#
#	if Input.is_action_just_pressed("Heavy Attack") && (current == "idle-2" || current == "walk 2"):
#		state_machine.travel("Sword Slash Down")
#		return
#
#	if Input.is_action_just_pressed("Heavy Attack") && current == "idle":
#		state_machine.travel("kick")
#		return
#
#	if Input.is_action_just_pressed("Draw Sword Sheathe Sword"):
#
#		if sworddrawn:
#			state_machine.travel("Sword Away")
#			sworddrawn = false
#			$AnimationTree["parameters/conditions/swordisdrawn"] = false
#
#		elif !sworddrawn:
#			state_machine.travel("Sword Draw")
#			sworddrawn = true
#			$AnimationTree["parameters/conditions/swordisdrawn"] = true
#
#	print(sworddrawn)
#	if Input.is_action_pressed("move_right"):
#
#		if current == "idle-2":
#			state_machine.travel("walk 2")
#
#		if current == "idle":
#			state_machine.travel("walk")
#
#		velocity.x += 1
#		$Sprite.scale.x = 1
#
#	if Input.is_action_pressed("move_left"):
#
#		if current == "idle-2":
#			state_machine.travel("walk 2")
#
#		if current == "idle":
#			state_machine.travel("walk")
#
#		velocity.x -= 1
#		$Sprite.scale.x = -1
#
#	if Input.is_action_just_pressed("jump"):
#		state_machine.travel("jump")
#		velocity.y = -Jump_speed
#
#		return
#
#	#velocity = velocity.normalized() * run_speed
#
#	if velocity.length() != 0 && sworddrawn:
#		state_machine.travel("walk 2")
#
#	elif velocity.length() != 0 && not sworddrawn:
#		state_machine.travel("walk")
#
#	if velocity.length() == 0 && sworddrawn:
#		state_machine.travel("idle-2")
#
#	elif velocity.length() == 0 && not sworddrawn:
#		state_machine.travel("idle")
##end region
func _physics_process(delta):
	if $RayCast2D.is_colliding():
		is_on_floor = 1

	var current = state_machine.get_current_node()

	velocity.y += _gravity
	if velocity.y > MAXFALLSPEED:
		velocity.y = MAXFALLSPEED
	if velocity.y > 0:
		state_machine.travel("fall")
	
	if Input.is_action_just_pressed("Light Attack"):
		if (current == "idle-2" || current == "walk 2"):
			state_machine.travel(attacks[randi()%2])
			return
		elif current == "idle":
			state_machine.travel("punch")
			return
		elif current == "walk":
			state_machine.travel("run-punch")
			return
	
	if Input.is_action_just_pressed("Heavy Attack"):
		if (current == "idle-2" || current == "walk 2"):
			state_machine.travel("attack1")
			return
		elif current == "idle":
			state_machine.travel("kick")
			return
		
	if Input.is_action_just_pressed("Draw Sword Sheathe Sword"):
		
		if sworddrawn:
			state_machine.travel("idle")
			sworddrawn = false
			#$AnimationTree["parameters/conditions/swordisdrawn"] = false
		
		elif !sworddrawn:
			state_machine.travel("idle-2")
			sworddrawn = true
			#$AnimationTree["parameters/conditions/swordisdrawn"] = true
	
	if Input.is_action_pressed("move_right"):
	
		if sworddrawn:
			state_machine.travel("walk 2")
	
		if not sworddrawn:
			state_machine.travel("walk")
	
		velocity.x = MAXSPEED
	
	elif Input.is_action_pressed("move_left"):
	
		if sworddrawn:
			state_machine.travel("walk 2")
	
		if not sworddrawn:
			state_machine.travel("walk")
	
		velocity.x = -MAXSPEED
	
	else:
		velocity.x = 0 
		if sworddrawn:
			state_machine.travel("idle-2")
		elif not sworddrawn:
			state_machine.travel("idle")
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -JUMPFORCE
			state_machine.travel("jump")
			return
	

#	if velocity.length() != 0 && sworddrawn:
#		state_machine.travel("walk 2")
#
#	elif velocity.length() != 0 && not sworddrawn:
#		state_machine.travel("walk")
#
#	if velocity.length() == 0 && sworddrawn:
#		state_machine.travel("idle-2")
#
#	elif velocity.length() == 0 && not sworddrawn:
#		state_machine.travel("idle")
	
	
	
	
	
	
	
	
	
	velocity = move_and_slide(velocity)





func hurt():
	state_machine.travel("hurt")
	
func die():
	state_machine.travel("die")
	set_physics_process(false)
	

#const GRAVITY = 100.0
#const WALK_SPEED = 200
#const Jump_speed = 40
#
#var velocity = Vector2()
#var is_on_floor = 0
#onready var _animation_player = $AnimationPlayer
#
#func _physics_process(delta):
#	velocity.y += delta * GRAVITY
#
#	if $RayCast2D.is_colliding():
#		is_on_floor = 1
#
#	if Input.is_action_pressed("move_left"):
#		velocity.x = -WALK_SPEED
#	elif Input.is_action_pressed("move_right"):
#		velocity.x =  WALK_SPEED
#	elif Input.is_action_just_released("jump")&& is_on_floor():
#		velocity.y = -Jump_speed * delta
#	else:
#		velocity.x = 0
#
#	# We dont need to multiply velocity by delta because "move_and_slide" already takes delta time into account.
#
#
#	# The second parameter of "move_and_slide" is the normal pointing up.
#	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
#	move_and_slide(velocity, Vector2(0, -1))
#
#func _process(_delta):#(Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"))
#	if  Input.is_action_pressed("move_right") && is_on_floor():
#		$Sprite.flip_h = false
#		_animation_player.play("walk")
#	elif Input.is_action_pressed("move_left")&& is_on_floor():
#		$Sprite.flip_h = true
#		_animation_player.play("walk")
#	elif Input.is_action_just_released("jump")&& is_on_floor():
#		_animation_player.play("jump")
#	elif is_on_floor == 1:
#		_animation_player.play("idle")
