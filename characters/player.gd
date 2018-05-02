extends Area2D

var type = 'main'
var stats
var status_effects = []

var overlapping_bodies = []
var is_hovering = false

var hand

var deck_manager

func add_test_status():
#  uncomment this shit if you want to test statuses
#  var status_scene = load("res://characters/status_effects.tscn")
#  var status = status_scene.instance()
#  status.status_name = 'quicken'
#  status_effects.append(status)
#
#  var status2 = status_scene.instance()
#  status2.status_name = 'quicken'
#  status_effects.append(status2)
  pass

func set_stats():
  stats.character_name = 'main'
  stats.max_energy = 4
  stats.energy = 4
  
  stats.starting_health = 200
  stats.health = 200
  stats.defense = 1 # base defense
  
  stats.front_row = true
  
func _on_Player_input_event(viewport, event, shape_idx):
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
    reference.hand.discard_card(ovlb)
  
func _ready():
  add_test_status()

  
  deck_manager = load("res://characters/deck_manager.tscn").instance()
  deck_manager.character = self
  deck_manager.hand = reference.hand
  deck_manager.prepare_deck_and_draw_pile(player_deck)
  
  connect("mouse_entered", self, "_mouse_over", [true])
  connect("mouse_exited",  self, "_mouse_over", [false])
  

  var stats_scene = load("res://characters/stats.tscn")
  stats = stats_scene.instance()
  stats.character = self
  set_stats()
  
  $PlayerShape/HealthBar.max_value = stats.starting_health
  $PlayerShape/HealthBar.min_value = 0	
  update_health()

  update_energy()
  

func reset_energy():
  stats.energy = stats.max_energy
  update_energy()
  
func update_health():
  $PlayerShape/HP.text = "hp: " + str(stats.health)
  $PlayerShape/HealthBar.value = stats.health
  if stats.health <= 0:
    you_dead()

func you_dead():
  print('dead')
  
func update_energy():
  $PlayerShape/Energy.text = "Energy: " + str(stats.energy)
  
func _check_alive():
  if stats.health <= 0:
    get_parent().queue_free()

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


