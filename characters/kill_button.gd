extends Button

func _ready():
	connect("button_up", self, "button_released")

func button_released():
	get_parent().get_parent().queue_free()