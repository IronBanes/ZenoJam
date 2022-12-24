class_name Skeley
extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
export var direction = -1
export var speed = 25
var state_machine 
var canattack = true
export (int) var hp = 100
export (int) var damage = 10

var Player = Player

export var attack_cooldown_time = 1000
export var next_attack_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():# Replace with function body.
	if direction == -1:
		$Sprite.scale.x = -1
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$player_checker.cast_to.x = -$player_checker.cast_to.x
	$attackray.cast_to.x = -$attackray.cast_to.x
	state_machine = $AnimationTree.get("parameters/playback")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_on_wall() or not $floor_checker.is_colliding():
		direction = direction * -1
		$Sprite.scale.x *= -1 
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
		$player_checker.cast_to.x = -$player_checker.cast_to.x
		$attackray.cast_to.x      = -$attackray.cast_to.x
	if $player_checker.is_colliding() && $floor_checker.is_colliding() && !$attackray.is_colliding():
		state_machine.travel("armed_walk")
		velocity.x = speed * direction
		
		$AnimationTree["parameters/conditions/IsArmedWalking"] = true
		$AnimationTree["parameters/conditions/IsAttacking"] = false
		
	if !$player_checker.is_colliding() && $floor_checker.is_colliding() && !$attackray.is_colliding():
		state_machine.travel("unarmed_walk")
		velocity.x = speed * direction
		
		$AnimationTree["parameters/conditions/IsArmedWalking"] = false
		$AnimationTree["parameters/conditions/IsAttacking"] = false
		
	if $attackray.is_colliding():
		var now = OS.get_ticks_msec()
		if now >= next_attack_time:
			velocity.x = 0 * direction
			state_machine.travel("skel_attack")
			canattack = false
		
			$AnimationTree["parameters/conditions/IsArmedWalking"] = false
			$AnimationTree["parameters/conditions/IsAttacking"] = true
			next_attack_time = now + attack_cooldown_time
		
		

	
	velocity.y += 20
	velocity = move_and_slide(velocity, Vector2.UP)

func takedamage(damage: int):
	hp -= damage
	print(hp)
	if hp > 0:
		hurt()
	else:
		die()


	
func hurt():
	
	state_machine.travel("hurt")
	
	velocity.x = 0

	if $AnimationTree.get("parameters/conditions/IsArmedWalking"):
		state_machine.travel("armed_walk")
	if $AnimationTree.get("parameters/conditions/IsAttacking"):
		state_machine.travel("skel_attack")

func die():
	state_machine.travel("die")
	set_process(false)
	$Timer.start()
	
func _on_Timer_timeout():
	queue_free()



func _on_HitBox_body_entered(body):
	if body is Player:
		body.takedamage(damage)
