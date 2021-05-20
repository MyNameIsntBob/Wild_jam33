extends 'res://Scripts/Character.gd'


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.hero = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func queue_free():
	return
