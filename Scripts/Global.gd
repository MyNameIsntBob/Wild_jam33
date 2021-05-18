extends Node


var player

var is_game_over := false
var current_gold = 0
var total_gold = 0

enum gold_types {
	BAR,
	COIN,
	CUP,
	FISH,
	FORK,
	ROCKET
}

var goblin_upgrades := {
	'armor': false
}

var gold_nodes = [
	preload("res://Prefabs/Gold/Bar.tscn"),
	preload("res://Prefabs/Gold/Coin.tscn"),
	preload("res://Prefabs/Gold/Cup.tscn"),
	preload("res://Prefabs/Gold/Fish.tscn"),
	preload("res://Prefabs/Gold/Fork.tscn"),
	preload("res://Prefabs/Gold/Rocket.tscn"),
]

func add_gold(amount):
	current_gold += amount
	total_gold += amount

func get_gold(type):
	return gold_nodes[type]
	
func game_over():
	is_game_over = true
	
func restart():
	current_gold = 0
	total_gold = 0
	is_game_over = false
	get_tree().reload_current_scene()
