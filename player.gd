extends Area2D

var starting_health = 20
var health = 20

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
		print('show player stats')
		
# may be useful later
#func _input(ev):
#    if ev.type == InputEvent.MOUSE_BUTTON:
#        if ev.pos > get_pos() && ev.pos < get_pos() + get_size():
#             #Do Things here, because mouse pointer is inside sprite