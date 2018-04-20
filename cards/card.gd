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

var scale_ratio_slow = 10
var inverse_scale_ratio_slow = pow(scale_ratio_slow, -1)

var player

#############################################
### card mechanic related stuff
#############################################

# active means it's available in the game
var active = true

var card_owner
var card_name = 'blank'
var description = ''

var damage = 5
var cost = 1
var effect
var actions = []
var target = ''

#############################################

#onready var card_display = get_node('Display')
#onready var card_title = $Display/Name
#onready var card_cost = $Display/Cost
#onready var card_description = $Display/Description

var card_display
var card_title
var card_cost
var card_description
var card_status_description

func reset_slow_card():
  unscale_for_slow_card()
  active = true
  get_node('DetectionArea').disabled = false

func return_to_owner_hand_pile():
  card_owner.deck_manager.add_to_hand_pile(self)

func send_to_owner_discard_pile():
  card_owner.deck_manager.add_to_discard_pile(self)
  
func enough_energy():
  return reference.player.stats.energy >= cost
  
func playable(target_object):
  return active && enough_energy() && !grabbed && active && target == target_object.type
  
func get_playable_actions(target):
  var playable_actions = []
  for action in actions:
    playable_actions.append(action)
#		if target.type == 'enemy' && action.enemy_targeting != null:
#			playable_actions.append(action)
#		if target.type == 'friend' && action.friend_targeting != null:
#			playable_actions.append(action)
#		if target.type == 'main' && action.main_targeting != null:
#			playable_actions.append(action)

  if not reference.player.stats.energy >= cost:
    playable_actions = []
  return playable_actions

func update_display():
  if card_display != null:
    card_title.text = card_name
    card_cost.text = str(cost)
    for action in actions:
      if description == null:
        description = ''
      description += action.description
    card_description.text = description

func _mouse_over(over):
  if over == true:
    is_hovering = true
    _scale_up()
    card_status_description.text = card_modifier_description()
  else:
    is_hovering = false
    if is_scaled_up == true:
      _scale_down()
    card_status_description.text = ''

func has_slow_actions():
  for action in actions:
    if action.priority == 'slow':
      return true
  return false
      
func card_modifier_description():
  var modifier_string = ''
  var modifiers = []
  if card_owner != null:
    modifiers = card_owner.stats.get_card_modifiers()
  for modifier in modifiers:
    if modifier == 'quicken' && has_slow_actions():
      modifier_string += "Card plays fast. "
    if modifier == 'strengthen':
      modifier_string += "Attacks are strengthened. "
  return modifier_string
  
func _scale_up():
  card_display.apply_scale(Vector2(scale_ratio, scale_ratio))
  is_scaled_up = true
  card_display.z_index = 10
  
func _scale_down():
  card_display.apply_scale(Vector2(inverse_scale_ratio, inverse_scale_ratio))
  is_scaled_up = false
  card_display.z_index = 1
  
func scale_for_slow_card():
  card_display.apply_scale(Vector2(inverse_scale_ratio_slow, inverse_scale_ratio_slow))
  input_pickable = false
  
func unscale_for_slow_card():
  card_display.apply_scale(Vector2(scale_ratio_slow, scale_ratio_slow))
  input_pickable = true

func _input(event):
#	if Input.is_mouse_button_pressed(BUTTON_LEFT):
  if event is InputEventMouseButton && event.pressed:

    if is_hovering == true && grabbed == false:
#			print("input_pickable is: ")
#			print(input_pickable)
      grabbed = true
      print('active: ', active)
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
      
#func remove():
#  if active == true:
#    reference.player.stats.energy -= cost
#    reference.player.update_energy()
#
#    active = false
#    get_parent().remove_card(self)
#    queue_free()

func discard():
  reference.player.stats.energy -= cost
  reference.player.update_energy()
  send_to_owner_discard_pile()

func _move_by_mouse():
  var mouse_pos = get_parent().get_local_mouse_position() # get_global_mouse_position()
#	var mouse_pos = get_parent().get_global_mouse_position()

  var this_pos = mouse_pos #-(local_mouse_pos)
#	print('mouse pos')
#	print(mouse_pos)
#	print('local mouse pos')
#	print(local_mouse_pos)
#	print('dif: ')
#	print(this_pos)

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
  
func to_data():
  return { 
    "name" : card_name,
    "card_target" : target,
    "effect" : effect,
    "cost" : cost,
    "description" : card_description,
    "actions" : action_data()
  }

func action_data():
  var action_data_temp = [] 
  for action in actions:
    action_data_temp.append(action.to_data())
  return action_data_temp
  
func load_action(action_data):
  var action_scene = load("res://cards/action.tscn")
  var action = action_scene.instance()
  
  action.action_name = action_data['action_name']
  action.description = action_data['description']
  action.target = action_data['target']
  
  action.priority = action_data['priority']
  action.trigger = action_data['trigger']
  action.multiplier = action_data['multiplier']
  action.turn = action_data['turn']
  action.duration = action_data['duration']
#	if action_data.has('enemy_targeting'):
#		action.enemy_targeting = action_data['enemy_targeting']
#	if action_data.has('friend_targeting'):
#		action.friend_targeting = action_data['friend_targeting']
#	if action_data.has('main_targeting'):	
#		action.main_targeting = action_data['main_targeting']
  
  action.attribute = action_data['attribute']
  action.effect	 = action_data['effect']
  action.value_min = action_data['value_min']
  action.value_max = action_data['value_max']
  
  action.card_owner = card_owner
  
  actions.append(action)

func _ready():
  card_display = get_node('Display')
  card_title = get_node('Display').get_node('Name')
  card_cost = $Display/Cost
  card_description = $Display/Description
  card_status_description = $Display/StatusDescription
  
  #    set_fixed_process(true)
  connect("mouse_entered", self, "_mouse_over", [true])
  connect("mouse_exited",  self, "_mouse_over", [false])
#	print(get_viewport().get_size())

  randomize()
  var redness = rand_range(0,1)
  randomize()
  var blueness = rand_range(0,1)
  randomize()
  var greenness = rand_range(0,1)
  
#	$Container/Display/Background.color = Color(redness, greenness, blueness, 1)
  player = get_parent().get_parent().get_node('Player')
  
  update_display()
  
  # font testing
  $TestLabel.set("z", 11)

