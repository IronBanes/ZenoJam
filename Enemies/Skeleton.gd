extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
export var direction = -1


# Called when the node enters the scene tree for the first time.
func _ready():# Replace with function body.
	if direction == -1:
		$Sprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_on_wall() or not $floor_checker.is_colliding():
		direction = direction * -1
		$Sprite.flip_h = not $Sprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	

	
	velocity.x = 10 * direction
	velocity = move_and_slide(velocity, Vector2.UP)
