extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var UPGRADES := preload("res://Prefabs/Upgrades.tscn")

var current_item

var items := [0, 1, 2]

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_item()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sign/Label.text = str(Global.current_gold)

func spawn_item():
	var item = items.pop_front()
	if item != null:
		var up = UPGRADES.instance()
		up.item_id = item
		up.position = $ItemSpawn.position
		add_child(up)
		current_item = up

func _on_Area2D_body_entered(body):
	for item in get_tree().get_nodes_in_group("Gold"):
		if item.player == body:
			item.queue_free()
			Global.add_gold(item.value)
			
	if $Horns and Global.current_gold > $Horns.cost:
		Global.current_gold -= $Horns.cost
		$Horns.pickup()
			

func _on_Platform1_body_entered(body):
	print("Buying Item")
	if current_item and current_item.cost <= Global.current_gold:
		Global.current_gold -= current_item.cost
		current_item.pickup()
		current_item = null
		spawn_item()
	


func _on_GoblinUpgrade_body_entered(body):
	if !Global.goblin_upgrades["armor"] and Global.current_gold >= 5:
		Global.current_gold -= 5
		Global.goblin_upgrades["armor"] = true
