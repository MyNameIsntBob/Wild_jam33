extends 'res://Scripts/Character.gd'


export var team : int
export var attack_damage : float
export var attack_range := 8
export var attack_speed := 0.5
export var chase_diration := 4

var target_out_of_range := false

var wander_time := 3.0
var wander_vary := 0.5
var wander_direction : Vector2
var is_wandering := false

var pick_up_timer 
var pick_up_time := 1.5
var picking_up := false
var target
var targets : Array

var ground_gold : Array
var gold_target 
var inventory := []

var attack_ready := true

enum states {
	WANDER,
	ATTACK,
	COLLECT
}
var state = states.WANDER


func _ready():
	pick_up_timer = Timer.new()
	pick_up_timer.set_wait_time(pick_up_time)
	self.add_child(pick_up_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if last_attacked_by:
		target = last_attacked_by
		last_attacked_by = null
	
	walking = state == states.WANDER
	
	if state == states.WANDER:
		wander_state(delta)
	if state == states.ATTACK:
		attack_state(delta)
	if state == states.COLLECT:
		collect_state(delta)

func wander_state(delta):
	if len(targets) > 0:
		state = states.ATTACK
		
	if len(ground_gold) > 0:
		state = states.COLLECT
		
	if is_wandering:
		input_vector = wander_direction
	else:
		change_wander_direction()
#	input_vector = Vector.ZERO
	
func attack_state(delta):
	if target_out_of_range and len(targets) > 0:
		target = null
		$ChaseTimer.stop()
	
	input_vector = Vector2.ZERO
	if !target or !is_instance_valid(target):
		set_target()
		
		if len(targets) > 0:
			targets.shuffle()
			target = targets[0]
			target_out_of_range = false
		else:
			state = states.WANDER
			return
	
	else:
		
		if target.position.distance_to(self.position) > attack_range:
			input_vector = target.position - self.position
		else:
			if attack_ready:
				attack()
				
func set_target():
	if target in targets:
		if !is_instance_valid(target):
			targets.erase(target)
	
	if len(targets) < 1:
		return
	
	targets.shuffle()
	target = targets[0]
	
func collect_state(delta):
	if len(targets) > 0:
		state = states.ATTACK
		
	input_vector = Vector2.ZERO
	if !gold_target or !is_instance_valid(gold_target):
		if gold_target in ground_gold:
			ground_gold.erase(gold_target)
		gold_target = null

		if len(ground_gold) > 0:
			ground_gold.shuffle()
			gold_target = ground_gold[0]
		else:
			state = states.WANDER
			return
	
	else:
		if gold_target.position.distance_to(self.position) > attack_range:
			input_vector = gold_target.position - self.position
		else:
			if !picking_up:
				pickup()
	
func change_wander_direction():
	is_wandering = true
	wander_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	$WanderTimer.wait_time = rand_range(wander_time - wander_vary, wander_time + wander_vary)
	$WanderTimer.start()
	
func pickup():
	picking_up = true
	pick_up_timer.start()
	yield(pick_up_timer, 'timeout')
	picking_up = false
	inventory.append(gold_target)
	self.get_parent().remove_child(gold_target)
	ground_gold.erase(gold_target)
	gold_target = null

func attack():
#	Add an attack
	attacking = true
	attack_ready = false
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Attack")
	yield($AnimationPlayer, 'animation_finished')
	attacking = false
	
	if target and is_instance_valid(target) and target.position.distance_to(self.position)  <= attack_range + 3:
		target.take_damage(attack_damage, self)
	
	$AttackTimer.wait_time = (1/attack_speed) + rand_range(-0.2, 0.2)
	$AttackTimer.start()
	

func queue_free():
	for item in inventory:
		if is_instance_valid(item):
			item.global_position = self.global_position
			get_parent().add_child(item)
	.queue_free()

func _on_WanderTimer_timeout():
	is_wandering = false

func _on_ChaseTimer_timeout():
	target = null

func _on_AttackTimer_timeout():
	attack_ready = true

func _on_Area2D_body_entered(body):
	
	if body.is_in_group("Gold"):
		ground_gold.append(body)
	
	if body.is_in_group('Character'):
		if body == target:
			target_out_of_range = false
			$ChaseTimer.stop()
		elif target_out_of_range:
			target = body
		
		if body.team != self.team:
			targets.append(body)

func _on_Area2D_body_exited(body):
	
	if body.is_in_group("Gold"):
		if body in ground_gold:
			ground_gold.erase("body")
	
	if body.is_in_group("Character"):
		if body == target:
			if len(targets) > 1:
				set_target()
			target_out_of_range = true
			$ChaseTimer.wait_time = chase_diration
			$ChaseTimer.start()
		
		if body in targets:
			targets.erase(body)
