extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var value = 0 setget set_value
var guihealth = $"../Player/Player.gd".hp
# Called when the node enters the scene tree for the first time.

func set_value(val):
	value = val
	text = "Health: " + str(guihealth)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
