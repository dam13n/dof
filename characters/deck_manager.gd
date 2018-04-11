extends Node

var character
var deck
var hand_pile = []
var draw_pile = []
var discard_pile = []
var hand

func draw_hand():
  for card in draw_pile:
    hand_pile.append(card)
  show_hand()

func show_hand():
  hand.clear_cards()
  for card in hand_pile:
    hand.add_card(card.to_data(), character)
    #hand.active_hand.append(card)
    hand.set_card_destinations()
    hand.organize()

func prepare_deck_and_draw_pile(character_deck):
  var deck_data = character_deck.deck_data()
  for card_data in deck_data:
    var card = make_card(card_data)
    draw_pile.append(card)
  draw_hand()
  
  
func _ready():
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
    card.apply_scale(Vector2(0.25,0.25))

    return card