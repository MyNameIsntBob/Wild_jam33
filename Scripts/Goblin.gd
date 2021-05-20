extends 'res://Scripts/Character.gd'

export var attack_range := 8
var padding := 0.5
export var attack_damage : float
export var attack_speed := 0.5
var target
var attack_ready := true

var path

onready var nav_2d : Navigation2D = find_parent("Master").get_node("Navigation2D") 

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_ReloadPathTimer_timeout()

func queue_free():
	var newGold = Global.get_gold(Global.gold_types.BAR).instance()
	get_parent().add_child(newGold)
	newGold.position = self.position
	.queue_free()

func _process(delta):
	input_vector = Vector2.ZERO
	if !Global.hero || !is_instance_valid(Global.hero):
		return
		
	if !target:
		nextTarget()
		return
	
	if Global.hero.global_position.distance_to(self.global_position) > attack_range:
		if target.distance_to(self.position) > padding:
			input_vector = (target - self.position).normalized()
		else:
			nextTarget()
	else:
		if attack_ready:
			attack()

func nextTarget():
	if path.size() <= 0:
		return 
	
	target = path[0]
	path.remove(0)

func attack():
#	Add an attack
	attack_ready = false
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Attack")
	yield($AnimationPlayer, 'animation_finished')
	
#	if Global.hero and is_instance_valid(Global.hero) and Global.hero.global_position.distance_to(self.global_position)  <= attack_range + 3:
#		target.take_damage(attack_damage, self)
	
	$AttackTimer.wait_time = (1/attack_speed) + rand_range(-0.2, 0.2)
	$AttackTimer.start()

func _on_AttackTimer_timeout():
	attack_ready = true


func _on_ReloadPathTimer_timeout():
	path = nav_2d.get_simple_path(self.global_position, Global.hero.global_position)
