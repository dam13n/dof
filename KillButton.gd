extends Button


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("button_up", self, "button_released")

func button_released():
	print('button')
	get_parent().queue_free()