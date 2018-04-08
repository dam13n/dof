extends Button

func _ready():
	connect("button_up", self, "button_released")

func button_released():
	print('button')
	get_parent().get_parent().queue_free()