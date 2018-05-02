  extends Area2D

var type = 'friend'
var image_path

var stats
var status_effects = []

var overlapping_bodies = []
var is_hovering = false

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


func set_stats():
  stats.character_name = 'friend'
  stats.starting_health = 150
  stats.health = 150
  stats.defense = 1.0 # base defense
  stats.strength = 1.0
  stats.critical_chance = 0.50
  
  stats.front_row = true
  
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
    reference.hand.discard_card(ovlb)
  
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

func update_display():
  var imagetexture = ImageTexture.new()
  imagetexture.load("./images/" + image_path)
  $Sprite.set_texture(imagetexture)
    
func _ready():
  add_test_status()
  
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
