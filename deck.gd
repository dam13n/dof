extends Node

var deck_data
var hand
var deck_owner

func _ready():
	hand = get_parent().get_node('Hand')
		
func make_cards():
	deck_data = get_deck_data()
	for card_data in deck_data:
		
		var card_scene = load("res://cards/card.tscn")
		var card = card_scene.instance()
#		card.set_name("card")
		
#		card.visible = false
#		card.input_pickable = false
		card.card_name = card_data['name']
		card.target = card_data['card_target']
		card.effect = card_data['effect']
#		card.damage = card_data['damage']
		card.cost = card_data['cost']
		card.description = card_data['description']
		for action_data in card_data['actions']:
			card.load_action(action_data)
		card.update_display()
		card.apply_scale(Vector2(0.25,0.25))
			
		hand.add_child(card)
		hand.active_hand.append(card)
		hand.set_card_destinations()
		hand.organize()
		
func get_deck_from_file():
	var deck_file = File.new()
	if not deck_file.file_exists("user://deck.csv"):
        return # Error!  We don't have a save to load.
	
