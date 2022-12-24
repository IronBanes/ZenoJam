class_name FireSlime
extends KinematicBody2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var hp = 100
export (int) var damage = 10

var velocity = Vector2()
export var direction = -1
export var speed = 25
var state_machine 

export var jumpspeed = 0.7

export var max_move_time = 5
export var move_time_interval = 0.1
export var wait_timer = 10
var wait = wait_timer
var current_move_time = 0


# Called when the node enters the scene tree for the first time.
func _ready():# Replace with function body.
	if direction == -1:
		$Sprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	state_machine = $AnimationTree.get("parameters/playback")
	$AnimationTree["parameters/jump/Jump Speed/scale"] =  jumpspeed
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_on_wall() or not $floor_checker.is_colliding():
		direction = direction * -1
		$Sprite.flip_h = not $Sprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	if current_move_time >= max_move_time && $floor_checker.is_colliding():
		velocity.x = speed * direction
		state_machine.travel("jump")
		current_move_time = 0
		wait = wait_timer
	
	elif current_move_time < max_move_time:
		velocity.x = lerp(velocity.x, 0, 0.1)
		velocity.y = 20
		if wait <= 0: 
			current_move_time += move_time_interval
			
		else:
			wait -= 0.1
		
		


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
	set_process(false)
	$Timer.start()


func _on_Timer_timeout():
	queue_free()


func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		body.takedamage(damage)

