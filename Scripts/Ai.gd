extends 'res://Scripts/Character.gd'


export var team : int
export var attackDamage : float
export var attackRange := 8
export var attackSpeed := 0.5
export var chaseDiration := 4

var target_out_of_range := false

var target
var targets : Array

var gold

var items := [
	
]

var attackReady := true

enum states {
	WANDER,
	ATTACK,
	COLLECT
}
var state = states.WANDER


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == states.WANDER:
		wander_state(delta)
	if state == states.ATTACK:
		attack_state(delta)
	if state == states.COLLECT:
		collect_state(delta)

func wander_state(delta):
	if len(targets) > 0:
		state = states.ATTACK
		
#	input_vector = 
#	pass
	
func attack_state(delta):
	if target_out_of_range and len(targets) > 0:
		target = null
		$ChaseTimer.stop()
	
	input_vector = Vector2.ZERO
	if !target or !is_instance_valid(target):
		if len(targets) > 0:
			targets.shuffle()
			target = targets[0]
			target_out_of_range = false
		else:
			state = states.WANDER
			return
	
	else:
		if !is_instance_valid(target):
			if target in targets:
				targets.erase(target)
			target = null
		
		if target.position.distance_to(self.position) > attackRange:
			input_vector = target.position - self.position
		else:
			if attackReady:
				attack()
				
func collect_state(delta):
	if len(targets) > 0:
		state = states.ATTACK
		
	
	pass
			
func attack():
#	Add an attack
	attacking = true
	attackReady = false
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Attack")
	yield($AnimationPlayer, 'animation_finished')
	attacking = false
	if target.position.distance_to(self.position)  <= attackRange + 3:
		target.take_damage(attackDamage)
	
	$AttackTimer.wait_time = (1/attackSpeed) + rand_range(-0.2, 0.2)
	$AttackTimer.start()
	

func _on_ChaseTimer_timeout():
	target = null

func _on_AttackTimer_timeout():
	attackReady = true

func _on_Area2D_body_entered(body):
	if body == target:
		target_out_of_range = false
		$ChaseTimer.stop()
	
	if body.team != self.team:
		targets.append(body)

func _on_Area2D_body_exited(body):
	if body == target:
		target_out_of_range = true
		$ChaseTimer.wait_time = chaseDiration
		$ChaseTimer.start()
	
	if body in targets:
		targets.erase(body)
