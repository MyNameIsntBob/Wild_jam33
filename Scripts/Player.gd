extends 'res://Scripts/Character.gd'

var team = 1

var has_shoes := false

onready var bigHorns = preload("res://Art/Characters/MainCharacterLongHorns-Sheet.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self
	$Shoes.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength('ui_left')
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if has_shoes and Input.is_action_just_pressed("run"):
		running = true
		
		
	if Input.is_action_just_released("run"):
		running = false

#Upgrades
func add_horns():
	$Sprite.texture = bigHorns
	var pol = $CollisionPolygon2D.get_polygon()
	for v in [0, 11, 8, 7]:
		pol.set(v, Vector2(pol[v].x, -1))
	$CollisionPolygon2D.set_polygon(pol)

func add_shoes():
	$Shoes.show()
	has_shoes = true
	
func add_armor():
	armor = true


#Do Specific stuff when the character is deleted
func queue_free():
#	Add a respawn mechanic
	Global.game_over()

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
	
	
