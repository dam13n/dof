extends HBoxContainer

var current_character
var width
#var active_hand = []

func _ready():
  width = get_size().x

func return_cards():
  for card in get_children():
    remove_child(card)
    card.return_to_owner_hand_pile()
  

func move_card(card, card_owner):
  add_child(card)

func add_card_from_data(card_data, card_owner):
  var card = make_card(card_data, card_owner)
  add_child(card)

func make_card(card_data, card_owner):
  var card_scene = load("res://cards/card.tscn")
  var card = card_scene.instance()
  
  card.card_owner = card_owner

  card.card_name = card_data['name']
  card.target = card_data['card_target']
  card.effect = card_data['effect']

  card.cost = card_data['cost']
  card.description = card_data['description']
  for action_data in card_data['actions']:
    card.load_action(action_data)
  card.update_display()
#  card.apply_scale(Vector2(0.3,0.3))

  return card


func clear_cards():
  for child in get_children():
    remove_child(child)
  
func discard_cards():
  for card in get_children():
    remove_child(card)
    card.send_to_owner_discard_pile()
  
func set_card_destinations():
  for i in range(0, get_children().size()):
    var child = get_children()[i]
    var pos_x = width/(get_children().size()+1)*(i+1)
    child.destination = Vector2(pos_x, 0)

func organize():
  for i in range(0, get_children().size()):
    var child = get_children()[i]
    child.reset_position()
    
func discard_card(card):
  remove_child(card)
  card.discard()
  set_card_destinations()
  organize()

