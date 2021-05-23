extends KinematicBody2D

export var armor := false
export var max_hp := 5.0

export var nock_back : int

export var attack_range := 8.0
export var attack_damage : float

var nocking_back := false

var attacking := false
var hp : float

var input_vector := Vector2.ZERO

var acceleration := 80.0
var normal_speed := 15.0
var run_speed := 30.0
var running := false
var walk_speed := 5.0
var walking := false
var velocity := Vector2.ZERO
var friction := 0.2

var inertia = 10

var last_attacked_by
var shoes 

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	hp = max_hp
	shoes = get_node('Shoes')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0:
		self.queue_free()
		
	if input_vector.x != 0:
		$Sprite.flip_h = input_vector.x < 0
		$Armor.flip_h = $Sprite.flip_h
		if shoes:
			shoes.flip_h = $Sprite.flip_h
#		if input_vector.x > 0:
#			$Sprite.frame_coords.y = 1
#		else:
#			$Sprite.frame_coords.y = 0
		
#	if attacking:
#		if $AnimationPlayer.current_animation != 'Attack':
#			$AnimationPlayer.stop()
#			$AnimationPlayer.play("Attack")
	if !attacking:
		if input_vector != Vector2.ZERO:
			if running:
				if $AnimationPlayer.current_animation != 'Run':
					$AnimationPlayer.stop()
					$AnimationPlayer.play("Run")
			else:
				if $AnimationPlayer.current_animation != 'Walk':
					$AnimationPlayer.stop()
					$AnimationPlayer.play("Walk")
		else:
			if $AnimationPlayer.current_animation != 'Idle':
				$AnimationPlayer.stop()
				$AnimationPlayer.play("Idle")
		
	$Armor.visible = armor

func take_damage(amount, attacker = null):
	if armor:
		amount = amount / 2
	hp -= amount
	
	if attacker:
		last_attacked_by = attacker
#		print(velocity) 
#		print((self.global_position - attacker.global_position).normalized())
		velocity = (self.global_position - attacker.global_position).normalized() * nock_back
		nocking_back = true
#		print(velocity)
#		velocity = Vector2.RIGHT * 1000


func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, PI/4, true)
	
	if !nocking_back:
		if input_vector != Vector2.ZERO and !attacking:
			velocity += input_vector * acceleration * delta
			if running:
				velocity = velocity.clamped(run_speed)
			elif walking:
				velocity = velocity.clamped(walk_speed)
			else:
				velocity = velocity.clamped(normal_speed)
		else:
			velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction/2)
		
		if velocity.distance_to(Vector2.ZERO) < 10:
			nocking_back = false
	
#	for index in get_slide_count():
#		var collision = get_slide_collision(index)
#		if collision.collider.is_in_group("Gold"):
#			print("Apply force")
#			print(collision)
#			collision.
#			collision.collider.apply_central_impulse(-collision.normal * inertia)
