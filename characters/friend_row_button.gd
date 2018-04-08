extends Button

func _ready():
	connect("button_up", self, "button_released")
#	update_display()

func button_released():
	get_parent().stats.front_row = !get_parent().stats.front_row
	update_display()
	
func update_display():
	if get_parent().stats.front_row:
		text = 'In Front'
	else:
		text = 'In Back'