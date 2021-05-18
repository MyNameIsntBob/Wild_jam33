extends Node2D

export var hero : bool

onready var HERO = preload("res://Prefabs/Hero.tscn")
onready var GOBLIN = preload("res://Prefabs/Goblin.tscn")

var wave_counter := 0

var spawning := false

var group
var goblins_in_wave := 0

func _ready():
	if hero:
		group = 'Hero'
	else:
		group = 'Goblin'

func _process(delta):
	if len(get_tree().get_nodes_in_group(group)) == 0 and !spawning:
		spawning = true
		wave_counter += 1
		goblins_in_wave = 0
		$Timer.start()

func spawn():
	var newGoblin
	if hero:
		newGoblin = HERO.instance()

	else:
		newGoblin = GOBLIN.instance()
	
	newGoblin.position = self.position
	get_parent().add_child(newGoblin)

func _on_Timer_timeout():
	goblins_in_wave += 1
	spawn()
	if goblins_in_wave < wave_counter:
		$Timer.start()
	else:
		spawning = false
	
