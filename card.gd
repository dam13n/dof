extends KinematicBody2D

var is_hovering = false
var pos = Vector2()
var grabbed = false
var local_mouse_pos = Vector2()
var damage = 5
var destination = Vector2()
var move_to_destination = false
var speed = 10
var active = true


func _ready():
	#    set_fixed_process(true)
	connect("mouse_entered", self, "_mouse_over", [true])
	connect("mouse_exited",  self, "_mouse_over", [false])
#	print(get_viewport().get_size())


func _mouse_over(over):
	if over == true:
		is_hovering = true
	else:
		is_hovering = false


func _input(event):
#	if Input.is_mouse_button_pressed(BUTTON_LEFT):
	if event is InputEventMouseButton && event.pressed:
		if is_hovering == true && grabbed == false:
			grabbed = true
			local_mouse_pos = get_local_mouse_position()
		else:
			grabbed = false
	elif event is InputEventMouseButton && !event.pressed:
		if grabbed == true:
			grabbed = false
			reset_position()
		
	if event is InputEventMouseMotion && grabbed == true:
		_move_by_mouse()

func reset_position():
	move_to_destination = true

func _physics_process(delta):
	if grabbed == false && move_to_destination == true:
		var direction = (destination-position)
		
		var motion = direction.normalized() * delta * speed*direction.length()
#		print(direction)
#		print(motion)
		position += motion
		if direction.length() < 0.1:
			move_to_destination = false
			
func remove():
	if active == true:
		active = false
		get_parent().remove_card(self)
		queue_free()

func _move_by_mouse():
	var mouse_pos = get_parent().get_local_mouse_position() # get_global_mouse_position()
#	var mouse_pos = get_parent().get_global_mouse_position()
	var this_pos = mouse_pos-(local_mouse_pos)

#	var view_size = OS.get_screen_size()

	# make sure object does not get dragged out of screen
#	if this_pos.x < 0:
#		this_pos.x = 0
#	if this_pos.y < 0:
#		this_pos.y = 0
#	if this_pos.x > view_size.x:
#		this_pos.x = view_size.x
#	if this_pos.y > view_size.y:
#		this_pos.y = view_size.y

	position = this_pos

