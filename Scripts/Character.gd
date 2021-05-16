extends KinematicBody2D

export var armor := false
export var max_hp := 5

var attacking := false
var hp : int

var input_vector := Vector2.ZERO

var acceleration := 80
var walk_speed := 15
var run_speed := 30
var running := false
var velocity := Vector2.ZERO
var friction := 0.2

var inertia = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	hp = max_hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0:
		self.queue_free()
		
	if input_vector.x != 0:
		$Sprite.flip_h = input_vector.x < 0
		$Armor.flip_h = $Sprite.flip_h
#		if input_vector.x > 0:
#			$Sprite.frame_coords.y = 1
#		else:
#			$Sprite.frame_coords.y = 0
		
	if attacking:
		if $AnimationPlayer.current_animation != 'Attack':
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Attack")
	else:
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

func take_damage(amount):
	hp -= amount


func _physics_process(delta):
	if input_vector != Vector2.ZERO and !attacking:
		velocity += input_vector * acceleration * delta
		if running:
			velocity = velocity.clamped(run_speed)
		else:
			velocity = velocity.clamped(walk_speed)
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
		
	velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, PI/4, true)
	
#	for index in get_slide_count():
#		var collision = get_slide_collision(index)
#		if collision.collider.is_in_group("Gold"):
#			print("Apply force")
#			print(collision)
#			collision.
#			collision.collider.apply_central_impulse(-collision.normal * inertia)
