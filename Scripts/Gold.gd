extends RigidBody2D

# Set the ground position


var player
var shadow

onready var shadow_path = preload('res://Prefabs/Shadow.tscn')

var on_ground := true
var ground_level := 6
var spawn_height := -10

var default_mask
var default_layer

var ground_layer := 4

#How much it sells for
export var value = 1

#Bodies currently touching this gold
var bodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	shadow = shadow_path.instance()
	default_mask = collision_mask
	default_layer = collision_layer
	if on_ground:
		set_on_ground()
	else:
		set_held()
#	self.add_child(shadow)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_ground:
		ground_process(delta)
	
	else:
		held_process(delta)
	
#	var force = Vector2.ZERO
#	for body in bodies:
#		force += body.velocity
#	linear_velocity = force


func ground_process(delta):
	if Input.is_action_just_pressed("ui_select") and len(bodies) >= 1:
		set_held()

func set_held():
	player = bodies[0]
	self.position.y = player.position.y + spawn_height
	mode = RigidBody2D.MODE_RIGID
	self.gravity_scale = 1
	on_ground = false
	collision_mask = default_mask
	collision_layer = default_layer
	
func held_process(delta):
	var current_ground_level = player.position.y + ground_level
#	shadow.position.y = currentGroundLevel
#	shadow.global_position.y = currentGroundLevel
#	shadow.global_position.x = self.global_position.x
#	shadow.Global.x = self.position.x
	if self.position.y > current_ground_level:
		set_on_ground()
		
func set_on_ground():
	player = null
	self.gravity_scale = 0
	mode = RigidBody2D.MODE_STATIC
#		linear_velocity = Vector2.ZERO
	on_ground = true
	collision_mask = 0
	collision_layer = ground_layer


func _on_Area2D_body_entered(body):
	bodies.append(body)
	


func _on_Area2D_body_exited(body):
	if body in bodies:
		bodies.erase(body)
