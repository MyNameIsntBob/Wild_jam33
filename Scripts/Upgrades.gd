extends Node

var item_id := 0
var cost := 5

var costs := [5, 10, 20, 3]

enum ITEMS {
	SHOES,
	HORNS,
	ARMOR,
	POTIONS
}

# Called when the node enters the scene tree for the first time.
func _ready():
	cost  = costs[item_id]
	$Sprite.frame += item_id
#	item_id = ITEMS.SHOES

func pickup():
	if item_id == ITEMS.HORNS:
		horns()
		
	if item_id == ITEMS.SHOES:
		shoes()

	if item_id == ITEMS.ARMOR:
		armor()
		
	if item_id == ITEMS.POTIONS:
		potion()


func horns():
	Global.player.add_horns()
	self.queue_free()

func shoes():
	Global.player.add_shoes()
	self.queue_free() 

func armor():
	Global.player.add_armor()
	self.queue_free() 
	
func potion():
	Global.player.hp += 1
	if Global.player.max_hp <= Global.player.hp:
		Global.player.hp = Global.player.max_hp
