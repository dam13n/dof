extends Node

var character
var deck
var hand_pile = []
var draw_pile = []
var discard_pile = []
var hand

var drawn_this_turn = false

func add_to_hand_pile(card):
  hand_pile.append(card)
  
func add_to_discard_pile(card):
  discard_pile.append(card)
  
func draw_hand():
  hand_pile = []
  for i in range(reference.DRAW):
    if draw_pile.empty():
      discard_to_draw_pile()
    
    var card = draw_pile.front()
    draw_pile.pop_front()
    hand_pile.append(card)
    drawn_this_turn = true
  

func discard_to_draw_pile():
  for card in discard_pile:
    draw_pile.append(card)
    discard_pile.erase(card)

func discard_hand():
  for card in hand_pile:
    #if character.type == 'main':
    #  print('char discard card')
    discard_pile.append(card)
  hand_pile.clear()
  #print(character.type, ' discard pile size: ', discard_pile.size())

func show_hand():
  reference.world.return_hand()
  #hand.clear_cards()
  if !drawn_this_turn:
    draw_hand()
  for card in hand_pile:
    
    hand.move_card(card, character)
    #hand.active_hand.append(card)
    hand.set_card_destinations()
    hand.organize()
  hand_pile.clear()

func prepare_deck_and_draw_pile(character_deck):
  var deck_data = character_deck.deck_data()
  for card_data in deck_data:
    var card = make_card(card_data)
    draw_pile.append(card)
  
  
func _ready():
  # not firing right now cuz not added as child anywhere?
  print('handing')
  hand = character.hand
  
func make_card(card_data):
    var card_scene = load("res://cards/card.tscn")
    var card = card_scene.instance()
    
    card.card_owner = character

    card.card_name = card_data['name']
    card.target = card_data['card_target']
    card.effect = card_data['effect']

    card.cost = card_data['cost']
    card.description = card_data['description']
    
    for action_data in card_data['actions']:
      card.load_action(action_data)
    card.update_display()
    card.apply_scale(Vector2(0.3, 0.3))

    return card