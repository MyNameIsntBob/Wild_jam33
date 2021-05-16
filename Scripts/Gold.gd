extends RigidBody2D

# Set the ground position


var player
var shadow

onready var shadowPath = preload('res://Prefabs/Shadow.tscn')

var onGround := true
var groundLevel := 6
var spawnHeight := -10

var defaultMask
var defaultLayer

#How much it sells for
export var value = 1

#Bodies currently touching this gold
var bodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	shadow = shadowPath.instance()
	defaultMask = collision_mask
	defaultLayer = collision_layer
	if onGround:
		set_on_ground()
	else:
		set_held()
#	self.add_child(shadow)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if onGround:
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
	self.position.y = player.position.y + spawnHeight
	mode = RigidBody2D.MODE_RIGID
	self.gravity_scale = 1
	onGround = false
	collision_mask = defaultMask
	collision_layer = defaultLayer
	
func held_process(delta):
	var currentGroundLevel = player.position.y + groundLevel
#	shadow.position.y = currentGroundLevel
#	shadow.global_position.y = currentGroundLevel
#	shadow.global_position.x = self.global_position.x
#	shadow.Global.x = self.position.x
	if self.position.y > currentGroundLevel:
		set_on_ground()
		
func set_on_ground():
	player = null
	self.gravity_scale = 0
	mode = RigidBody2D.MODE_STATIC
#		linear_velocity = Vector2.ZERO
	onGround = true
	collision_mask = 0
	collision_layer = 0


func _on_Area2D_body_entered(body):
	bodies.append(body)
	


func _on_Area2D_body_exited(body):
	if body in bodies:
		bodies.erase(body)
