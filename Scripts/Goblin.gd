extends 'res://Scripts/Character.gd'

var padding := 2
export var attack_speed := 0.5
var target
var attack_ready := true
var gold_drop := 1

var gold_to_drop := []

var path

onready var nav_2d : Navigation2D = find_parent("Master").get_node("Navigation2D") 

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_ReloadPathTimer_timeout()
	set_level()
	set_gold()
	
func set_level():
	var up = Global.goblin_upgrades
	max_hp += up["max_hp"]
	hp = max_hp
	armor = up['armor']
	attack_range += up["attack_range"]
	attack_damage += up["attack_damage"]
	normal_speed += up["move_speed"]
	gold_drop += up["gold_drop"]
	
func set_gold():
	gold_drop += rand_range(-3, 3)
	if gold_drop <= 0:
		gold_drop = 1
	gold_to_drop = Global.get_gold(gold_drop)
	

func queue_free():
	for gold in gold_to_drop:
		var newGold = gold.instance()
		get_parent().add_child(newGold)
		newGold.position = self.position + Vector2(rand_range(-3, 3), rand_range(-3, 3))
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
	attacking = true
	attack_ready = false
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Attack")
	yield($AnimationPlayer, 'animation_finished')
	
	attacking = false
	
#	if Global.hero and is_instance_valid(Global.hero) and Global.hero.global_position.distance_to(self.global_position)  <= attack_range + 3:
#		target.take_damage(attack_damage, self)
	
	$AttackTimer.wait_time = (1/attack_speed) + rand_range(-0.2, 0.2)
	$AttackTimer.start() 

func _on_AttackTimer_timeout():
	attack_ready = true


func _on_ReloadPathTimer_timeout():
	path = nav_2d.get_simple_path(self.global_position, 
		Global.hero.global_position) # + (Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * 2))
