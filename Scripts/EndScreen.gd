extends CanvasLayer

var label

# Called when the node enters the scene tree for the first time.
func _ready():
	label = find_node("Label")

func _process(delta):
	get_child(0).visible = Global.is_game_over
	
	label.text = 'You\'ve collected ' + str(Global.total_gold) + " gold."


func _on_Button_pressed():
	Global.restart()
