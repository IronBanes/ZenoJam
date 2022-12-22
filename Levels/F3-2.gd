extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$platform/AnimationPlayer.play("moving")
	$platform2/AnimationPlayer.play("moving2")
	$platform3/AnimationPlayer.play("moving2")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
