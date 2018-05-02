  extends Area2D

var type = 'friend'
var image_path

var stats
var status_effects = []

var overlapping_bodies = []
var is_hovering = false

#var deck
#var hand_pile = []
#var draw_pile = []
#var discard_pile = []
var hand

var deck_manager

func add_test_status():
  var status_scene = load("res://characters/status_effects.tscn")
  var quicken_status = status_scene.instance()
  quicken_status.status_name = 'quicken'
  status_effects.append(quicken_status)

  var parry_status = status_scene.instance()
  parry_status.status_name = 'parry'
  parry_status.value_min = 5
  status_effects.append(parry_status)
  
#	var strength_status = status_scene.instance()
#	strength_status.status_name = 'strengthen'
#	strength_status.value_min = 0.25
#	status_effects.append(strength_status)

func set_stats():
  stats.character_name = 'friend'
  stats.starting_health = 150
  stats.health = 150
  stats.defense = 1.0 # base defense
  stats.strength = 1.0
  stats.critical_chance = 0.50
  
  stats.front_row = true

#func add_status(action):
#  var status_already_applied = false
#  for status in status_effects:
#    if status.status_name == action.action_name:
#      status_already_applied = true
#      status.duration += action.duration
#
#  if not status_already_applied:
#    var status_scene = load("res://characters/status_effects.tscn")
#    var status = status_scene.instance()
#    status.attribute = action.attribute
#    status.value_min = action.value_min
#    status.value_max = action.value_max
#    status.status_name = action.action_name
#    status_effects.append(status)
#  update_info_node()
  

#func update_info_node():
#  $CharacterInfo.get_node('Statuses').text = ''
#  for status in status_effects:
#    $CharacterInfo.get_node('Statuses').text += str(status.duration) + ' ' + status.status_name


#func show_hand():
#  hand.clear_cards()
#  for card in hand_pile:
#    hand.add_card(card.to_data(), self)
#    #hand.active_hand.append(card)
#    hand.set_card_destinations()
#    hand.organize()
  
func _on_Friend_input_event(viewport, event, shape_idx):
  var ovlb
  if event is InputEventMouseButton && !event.pressed:
    overlapping_bodies = get_overlapping_areas()
    if overlapping_bodies.size() > 0:
      ovlb = overlapping_bodies[0]
    else:
      return
  else:
    return

  if ovlb.playable(self):
    var actions = ovlb.get_playable_actions(self)
    if actions.size() > 0:
      for action in actions:
        if action.target == 'card_owner':
          var card_owner = action.card_owner
          # this is a hackish way to stop an endless loop of trying to retarget card owner
          action.target = 'card_target'
          card_owner.stats.process_action(action)
        else:
          stats.process_action(action)
        
      _check_alive()
#      ovlb.discard()
    reference.hand.discard_card(ovlb)

#func process_action(action):
#  if action.target == 'card_target':
#    if action.attribute == 'health':
#  #		action.enemy_targeting['attribute']
#      var base_damage = int(rand_range(action.value_min, action.value_max)+0.5)
#      stats.inflict_damage(base_damage)
#
#    elif action.effect == 'status':
#      print('effect is status')
#      add_status(action)
#  elif action.target == 'card_owner':
#    var card_owner = action.card_owner
#    # this is a hackish way to stop an endless loop of trying to retarget card owner
#    action.target = 'card_target'
#    card_owner.process_action(action)
  
  
func reset_energy():
  update_energy()
  
func update_health():
  if stats.health >= stats.starting_health:
    stats.health = stats.starting_health
  $HP.text = "hp: " + str(stats.health)
  $HealthBar.value = stats.health
  if stats.health <= 0:
    you_dead()

func you_dead():
  queue_free()
  
func _check_alive():
  if stats.health <= 0:
    get_parent().queue_free()

#func draw_hand():
#  for card in draw_pile:
#    hand_pile.append(card)
#	show_hand()

#func prepare_deck_and_draw_pile():
#  var deck_data = friend_deck.deck_data()
#
#  for card_data in deck_data:
#
#    var card_scene = load("res://cards/card.tscn")
#    var card = card_scene.instance()
#
#    card.card_owner = self
#    card.card_name = card_data['name']
#    card.target = card_data['card_target']
#    card.effect = card_data['effect']
#
#    card.cost = card_data['cost']
#    card.description = card_data['description']
#    for action_data in card_data['actions']:
#      card.load_action(action_data)
#    card.update_display()
#    card.apply_scale(Vector2(0.25,0.25))
#
#    draw_pile.append(card)
#  draw_hand()

func update_display():
  var imagetexture = ImageTexture.new()
  imagetexture.load("./images/" + image_path)
  $Sprite.set_texture(imagetexture)
    
func _ready():
  add_test_status()
  
#  hand = load("res://characters/hand.tscn").instance()
#  hand.character = self
#  add_child(hand)
#  hand = get_parent().get_node('Hand')
  
  deck_manager = load("res://characters/deck_manager.tscn").instance()
  deck_manager.character = self
  deck_manager.hand = reference.hand
  deck_manager.prepare_deck_and_draw_pile(friend_deck)
  image_path = 'lazerd.png'
  

  connect("mouse_entered", self, "_mouse_over", [true])
  connect("mouse_exited",  self, "_mouse_over", [false])
  var stats_scene = load("res://characters/stats.tscn")
  stats = stats_scene.instance()
  stats.character = self
  set_stats()

  
  $HealthBar.max_value = stats.starting_health
  $HealthBar.min_value = 0
  update_health()
  
  update_display()

func _mouse_over(over):	
  if over == true:
    is_hovering = true
    $CharacterInfo.visible = true
  else:
    is_hovering = false
    $CharacterInfo.visible = false

func _input(event):
  if event is InputEventMouseButton && event.pressed && is_hovering == true:
    deck_manager.show_hand()
    
# may be useful later
#func _input(ev):
#    if ev.type == InputEvent.MOUSE_BUTTON:
#        if ev.pos > get_pos() && ev.pos < get_pos() + get_size():
#             #Do Things here, because mouse pointer is inside sprite
