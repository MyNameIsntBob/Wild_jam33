extends Node


var player

var gold = 0

enum goldTypes {
	BAR,
	COIN,
	CUP,
	FISH,
	FORK,
	ROCKET
}

var goldNodes = [
	preload("res://Prefabs/Gold/Bar.tscn"),
	preload("res://Prefabs/Gold/Coin.tscn"),
	preload("res://Prefabs/Gold/Cup.tscn"),
	preload("res://Prefabs/Gold/Fish.tscn"),
	preload("res://Prefabs/Gold/Fork.tscn"),
	preload("res://Prefabs/Gold/Rocket.tscn"),
]

func get_gold(type):
	return goldNodes[type]
	
