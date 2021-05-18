extends Node

var item_id := 0
var cost := 5

enum ITEMS {
	SHOES,
	HORNS,
	ARMOR
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.frame += item_id
#	item_id = ITEMS.SHOES

func pickup():
	if item_id == ITEMS.HORNS:
		horns()
		
	if item_id == ITEMS.SHOES:
		shoes()

	if item_id == ITEMS.ARMOR:
		armor()

	self.queue_free()

func horns():
	Global.player.add_horns()

func shoes():
	Global.player.add_shoes()

func armor():
	Global.player.add_armor()
