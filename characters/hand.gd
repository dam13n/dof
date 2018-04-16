extends HBoxContainer

var character
var width
#var active_hand = []

func _ready():
  rect_position = Vector2(300,600) - character.position
#  print(rect_position)
  #size = Vector2(1146,284)
  width = get_size().x
#	active_hand = get_children()
#	set_card_destinations()
#	organize()

#func add_card(card_data, card_owner):
#  var card = make_card(card_data, card_owner)
#  add_child(card)

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
  card.apply_scale(Vector2(0.1,0.1))

  return card


func clear_cards():
  for child in get_children():
    remove_child(child)
  
#func discard_cards():
#	for card in active_hand:		
#		card.queue_free()
#	active_hand = []
  
func set_card_destinations():
  for i in range(0, get_children().size()):
    var child = get_children()[i]
    var pos_x = width/(get_children().size()+1)*(i+1)
    child.destination = Vector2(pos_x, 0)

func organize():
  for i in range(0, get_children().size()):
    var child = get_children()[i]
    child.reset_position()
#		print('child count:', get_children().size())
    
func remove_card(card):
#	print('removing card')
#	var card_index = active_hand.find(card)
#	active_hand.remove(card_index)
  set_card_destinations()
  organize()

