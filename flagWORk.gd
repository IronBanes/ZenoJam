extends Area2D

export(String, FILE) var NEXT_LEVEL: String = ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	print("entered")
	get_tree().change_scene(NEXT_LEVEL)
