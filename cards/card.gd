extends KinematicBody2D

#############################################
### card physics and display
#############################################

var is_hovering = false
var is_scaled_up = false
var pos = Vector2()
var grabbed = false
var local_mouse_pos = Vector2()

var destination = Vector2()
var move_to_destination = false
var speed = 10

var scale_ratio = 1.25
var inverse_scale_ratio = pow(scale_ratio, -1)
var player

#############################################
### card mechanic related stuff
#############################################

# active means it's available in the game
var active = true

var card_name = 'blank'
var description = ''

var damage = 5
var cost = 1
var effect
var actions = []

#############################################

func _ready():
	randomize()
	#    set_fixed_process(true)
	connect("mouse_entered", self, "_mouse_over", [true])
	connect("mouse_exited",  self, "_mouse_over", [false])
#	print(get_viewport().get_size())

	var redness = rand_range(0,1)
	var blueness = rand_range(0,1)
	var greenness = rand_range(0,1)
	$Container/Display/Background.color = Color(redness, greenness, blueness, 1)
	player = get_parent().get_parent().get_node('Player')
	
	update_display()
	
func load_action(action_data):
	var action_scene = load("res://cards/Action.tscn")
	var action = action_scene.instance()
	
	action.action_name = action_data['action_name']
	action.description = action_data['description']
	
	action.priority = action_data['priority']
	action.trigger = action_data['trigger']
	action.multiplier = action_data['multiplier']
	action.turn = action_data['turn']
	action.duration = action_data['duration']
	action.enemy_targeting = action_data['enemy_targeting']
#	action.enemy_targeting = {
#		'attribute' : 'health',
#		'target' : 'single',
#		'value_min' : 10,
#		'value_max' : 20,
#		'status' : null
#	}	
	
	actions.append(action)
	
func get_playable_actions(target):
	var playable_actions = []
	for action in actions:
		if target.type == 'enemy' && action.enemy_targeting != null:
			playable_actions.append(action)
	if not player.energy >= cost:
		playable_actions = []
	return playable_actions

func update_display():
	$Container/Display/CardName.text = card_name
	$Container/Display/Cost.text = str(cost)
	for action in actions:
		description += action.description
	$Container/Display/Description.text = description

func _mouse_over(over):
	if over == true:
		is_hovering = true
		_scale_up()
	else:
		is_hovering = false
		if is_scaled_up == true:
			_scale_down()

			
func _scale_up():
	$Container/Display.apply_scale(Vector2(scale_ratio,scale_ratio))
	is_scaled_up = true
	$Container/Display.z_index = 10
	
func _scale_down():
	$Container/Display.apply_scale(Vector2(inverse_scale_ratio,inverse_scale_ratio))
	is_scaled_up = false
	$Container/Display.z_index = 1

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
	if is_scaled_up == true:
		_scale_down()
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
		player.energy -= cost
		player.update_energy()
		
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

