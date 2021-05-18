extends 'res://Scripts/Ai.gd'


#export var drop : Array

var speed_loss := 5

# Called when the node enters the scene tree for the first time.
func _ready():
	armor = Global.goblin_upgrades["armor"]
	pass
#	walk_speed -= speed_loss

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func queue_free():
	var newGold = Global.get_gold(Global.gold_types.BAR).instance()
	get_parent().add_child(newGold)
	newGold.position = self.position
	.queue_free()

