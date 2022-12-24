extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_flag_hitbox_body_entered(body):
	if body is Player:
		get_tree().change_scene("res://Levels/F2/F2-1.tscn")
		print("enter")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
