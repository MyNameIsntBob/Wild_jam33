extends Node

var player
var hero

var is_game_over := false
var current_gold = 0
var total_gold = 0

enum gold_types {
	COIN,
	BAR,
	FORK,
	ROCKET
	CUP,
	FISH,
}

var goblin_level := 0
var goblin_cost := 3
var wave_counter := 2

var goblin_upgrades := {
	'armor': false,
	'max_hp': 0,
	'attack_range': 0,
	'attack_damage': 0,
	'move_speed': 0,
	'gold_drop': 0
}

func level_up_goblin():
	if goblin_cost <= current_gold:
		current_gold -= goblin_cost
		
		if goblin_level == 0:
			goblin_upgrades["armor"] = true
			goblin_upgrades["gold_drop"] += 1
		
		else:
			if goblin_level % 2 == 0:
				wave_counter += 1
				goblin_upgrades["gold_drop"] += 1
			goblin_upgrades["attack_range"] += 0.1
			goblin_upgrades["attack_damage"] +=  1
			goblin_upgrades["move_speed"] += 0.2
		goblin_upgrades["max_hp"] += 0.2
		
		goblin_cost += 1
		goblin_level += 1

var gold_nodes = [
	preload("res://Prefabs/Gold/Coin.tscn"),
	preload("res://Prefabs/Gold/Bar.tscn"),
	preload("res://Prefabs/Gold/Fork.tscn"),
	preload("res://Prefabs/Gold/Rocket.tscn"),
	preload("res://Prefabs/Gold/Cup.tscn"),
	preload("res://Prefabs/Gold/Fish.tscn"),
]

var gold_values = [1, 3, 12, 14, 15, 18]

func add_gold(amount):
	current_gold += amount
	total_gold += amount

#func get_gold(type):
#	return gold_nodes[type]
	
func get_gold(amount):
	var gold := []
	
	while amount > 0:
		for i in range(len(gold_values)):
			var value = gold_values[i]
			if value <= amount:
				gold.append(gold_nodes[i])
				amount -= value
	return gold
	
func game_over():
	is_game_over = true
	
func restart():
	current_gold = 0
	total_gold = 0
	is_game_over = false
	goblin_upgrades = {
		'armor': false,
		'max_hp': 0,
		'attack_range': 0,
		'attack_damage': 0,
		'move_speed': 0,
		'gold_drop': 0
	}
	wave_counter = 2
	goblin_level = 0
	goblin_cost = 3
	
	get_tree().reload_current_scene()
