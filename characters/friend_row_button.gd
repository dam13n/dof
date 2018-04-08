extends Button

func _ready():
	connect("button_up", self, "button_released")
	update_display()

func button_released():
	print('row button')
	get_parent().front_row = !get_parent().front_row
	update_display()
	
func update_display():
	if get_parent().front_row:
		text = 'In Front'
	else:
		text = 'In Back'