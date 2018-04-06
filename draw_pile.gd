extends Area2D

var is_hovering = false

func _ready():
	connect("mouse_entered", self, "_mouse_over", [true])
	connect("mouse_exited",  self, "_mouse_over", [false])

func _mouse_over(over):
	if over == true:
		is_hovering = true
	else:
		is_hovering = false

func _input(event):
	if event is InputEventMouseButton && event.pressed && is_hovering == true:
		print('draw disabled here')
#		var deck_data = get_parent().get_node('Deck').get_deck_data()
#		get_parent().get_node('Deck').make_cards()