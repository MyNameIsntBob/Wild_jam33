extends 'res://Scripts/Character.gd'

var attack_ready := true
export var attack_speed := 0.5

var wander_dir : Vector2

enum Attacks {
	SWING,
	SPIN
}

var level := 1
var xp := 0
var xp_next_level := 2
var xp_increase := 2

var speed_increase := 0.5
var attack_increase := 0.5
var sword_increase := 0.15
var range_up := 0.1

var enemies = []
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_WanderTimer_timeout()
	Global.hero = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if xp >= xp_next_level:
		level_up()
	
	input_vector = Vector2.ZERO
	
	if !target:
		input_vector = wander_dir
		
		if input_vector.x > 0:
			$Hand.rotation = 0
		else:
			$Hand.rotation = 180
		
		if len(enemies) != 0:
			get_target()
			
	if target and is_instance_valid(target):
#		$velocity.linear_interpolate(Vector2.ZERO, friction)
		$Hand.look_at(target.position)
		if target.global_position.distance_to(self.global_position) <= attack_range and attack_ready:
			attack()
		input_vector = (target.global_position - self.global_position).normalized()
				
func level_up():
	xp -= xp_next_level
	xp_next_level += xp_increase
	normal_speed += speed_increase
	attack_range += range_up
	attack_damage += attack_increase
	$Hand.scale += Vector2(sword_increase, sword_increase)

func get_target():
	var closest 
	var distance
	for t in enemies:
		if !is_instance_valid(t):
			enemies.erase(t)
		else:
			var current_distance = t.global_position.distance_to(self.global_position)
			if !closest or current_distance < distance:
				distance = current_distance
				closest = t
	target = closest

func queue_free():
	return

func _on_AttackTimer_timeout():
	attack_ready = true


func _on_WanderTimer_timeout():
	wander_dir = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	wander_dir += ((find_parent("Master").get_node('Center').global_position - self.global_position)/4).normalized()
	wander_dir = wander_dir.normalized()
	
func attack():
#	Add an attack
	attack_ready = false
	attacking = true
	
	var anim = 'Attack'
	if level > 5 and rand_range(0, 1) == 0:
		anim = 'Spin'
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play(anim)
	yield($AnimationPlayer, 'animation_finished')
	
	attacking = false
#	if Global.hero and is_instance_valid(Global.hero) and Global.hero.global_position.distance_to(self.global_position)  <= attack_range + 3:
#		target.take_damage(attack_damage, self)
	
	$AttackTimer.wait_time = (1/attack_speed) + rand_range(-0.2, 0.2)
	$AttackTimer.start() 


func _on_Area2D_body_entered(body):
	if body != self:
		enemies.append(body)
		
		get_target()


func _on_Area2D_body_exited(body):
	if body in enemies:
		enemies.erase(body)
		
	if body == target:
		target = null
		get_target()


func _on_Sword_body_entered(body):
	if body != Global.player:
		xp += 1
	
	if body != self:
		body.take_damage(attack_damage, self)
		
		if !is_instance_valid(body):
			if body in enemies:
				enemies.erase(body)
		target = null
		get_target()
	pass # Replace with function body.
