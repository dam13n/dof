extends Area2D

var starting_health = 20
var health = 20
var energy = 4

var is_hovering = false

func _ready():
	connect("mouse_entered", self, "_mouse_over", [true])
	connect("mouse_exited",  self, "_mouse_over", [false])
	update_health()
	$PlayerShape/HealthBar.max_value = starting_health
	$PlayerShape/HealthBar.min_value = 0
	update_energy()
	
func update_health():
	$PlayerShape/HP.text = "hp: " + str(health)
	$PlayerShape/HealthBar.value = health
	
func update_energy():
	$PlayerShape/Energy.text = "Energy: " + str(energy)
	
func _check_alive():
	if health <= 0:
		get_parent().queue_free()

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