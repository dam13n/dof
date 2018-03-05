extends Node

var deck_data
var hand

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	hand = get_parent().get_node('Hand')

		
func make_cards():
	deck_data = get_deck_data()
	for card_data in deck_data:
		
		var card_scene = load("res://card.tscn")
		var card = card_scene.instance()
#		card.set_name("card")
		
#		card.visible = false
#		card.input_pickable = false
		card.card_name = card_data['name']
		card.damage = card_data['damage']
		card.cost = card_data['cost']
		hand.add_child(card)
		hand.active_hand.append(card)
		hand.set_card_destinations()
		hand.organize()
		
	
func get_deck_data():
	return [
		{ 
			"name" : "attack",
			"cost" : 2,
			"damage" : 10
		},
		{ 
			"name" : "attack",
			"cost" : 1,
			"damage" : 5
		},
		{ 
			"name" : "attack",
			"cost" : 1,
			"damage" : 3
		},
		{ 
			"name" : "attack",
			"cost" : 3,
			"damage" : 15
		},
		{ 
			"name" : "attack",
			"cost" : 2,
			"damage" : 11
		}
	]

