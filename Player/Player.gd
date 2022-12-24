class_name Player
extends KinematicBody2D

export (int) var speed = 150
export (int) var jump_speed = -275
export (int) var gravity = 380


export (int) var hp = 100

export (float, 0, 1.0) var friction = 0.9
export (float, 0, 1.0) var acceleration = 0.25

var velocity = Vector2.ZERO

var state_machine

var attacks = ["Sword Slash", "Sword Slash Down"]

var sworddrawn = false
export (int) var sword_attack_damage = 20
export (int) var melee_attack_damage = 10



func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	$AnimationTree["parameters/conditions/Landed"] = 0

func get_input():
	var current = state_machine.get_current_node()
	
	var dir = 0
	
	if Input.is_action_pressed("move_right"):
		
		if is_on_floor() && (current != "attack1" && current != "attack2"  && current != "attack3" && current != "Sword Slash" && current != "Slash Slash Down" && current != "run-punch" && current != "kick" && current != "punch"):
			if sworddrawn:
				state_machine.travel("walk 2")
			if not sworddrawn:
				state_machine.travel("walk")
	
		$Sprite.scale.x = 1
		dir += 1
	
	if Input.is_action_pressed("move_left"):
		if is_on_floor() && (current != "attack1" && current != "attack2"  && current != "attack3" && current != "Sword Slash" && current != "Slash Slash Down" && current != "run-punch" && current != "kick" && current != "punch"):
			if sworddrawn:
				state_machine.travel("walk 2")
			if not sworddrawn:
				state_machine.travel("walk")
		
		$Sprite.scale.x = -1
		dir -= 1
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			state_machine.travel("jump")
			velocity.y = jump_speed
	
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

		elif !sworddrawn:
			state_machine.travel("idle-2")
			sworddrawn = true
			
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	
	
	if velocity.y > -jump_speed:
		velocity.y = -jump_speed
	elif velocity.y > 0:
		state_machine.travel("fall 2")
	else:
		if sworddrawn && (current == "idle"):
			state_machine.travel("idle-2")
	
		
func _physics_process(delta):
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()
		
	get_input()
	var current = state_machine.get_current_node()
	velocity.y += gravity * delta
	
	if is_on_floor():
		$AnimationTree["parameters/conditions/Landed"] = 1
		
	else:
		$AnimationTree["parameters/conditions/Landed"] = 0
		
	if (abs(velocity.x) < acceleration && sworddrawn) && (current == "walk 2"):
		if is_on_floor():
			state_machine.travel("idle-2")
		
		
	elif (abs(velocity.x) < acceleration && !sworddrawn) && (current == "walk"):
		if is_on_floor():
			state_machine.travel("idle")
		
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
func takedamage(damage: int):
	hp -= damage
	if hp > 0:
		hurt()
	else:
		die()

func hurt():
	state_machine.travel("hurt")

func die():
	state_machine.travel("die")
	set_physics_process(false)

func _on_HitBox_Area2D_body_entered(body):
	if body is Skeley||FireSlime:
		if sworddrawn:
			body.takedamage(sword_attack_damage)
		elif !sworddrawn:
			body.takedamage(melee_attack_damage)
