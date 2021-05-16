extends 'res://Scripts/Character.gd'

var team = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength('ui_left')
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if Input.is_action_just_pressed("run"):
		running = true
		
		
	if Input.is_action_just_released("run"):
		running = false
			
func queue_free():
#	Add a respawn mechanic

#   Drop all of the items on the ground so they don't try to find the ground level based on a non existent character
	for item in get_tree().get_nodes_in_group("Gold"):
		if item.player == self:
			item.set_on_ground()

#	Make so the camera doesn't move
	var cam = $Camera2D
	self.remove_child(cam)
	cam.global_position = self.global_position
	get_parent().add_child(cam)
	.queue_free()
	
	
