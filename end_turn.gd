extends Button

func _ready():
	connect("button_up", self, "button_released")

func button_released():
	get_parent().get_node('Hand').clear_cards()
	get_parent().next_turn()