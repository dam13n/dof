extends Node

var deck_data
var hand
var deck_owner

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	hand = get_parent().get_node('Hand')
		
func make_cards():
	deck_data = get_deck_data()
	for card_data in deck_data:
		
		var card_scene = load("res://cards/card2.tscn")
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
	
func get_deck_data():
	return [
		{ 
			"name" : "slash",
			"card_target" : 'enemy',
			"effect" : "attack",
			"cost" : 2,
			"description" : '',
			"actions" : [
				{
					'action_name' : 'attack',
					"effect" : "attack",
					'description' : 'Does 10-20 damage. ',
					'priority' : 'slow',
					'trigger' : null,
					'multiplier' : null,
					'turn' : 0,
					'duration' : 1,
					'attribute' : 'health',
					'target' : 'single',
					'value_min' : 10,
					'value_max' : 20,
					'status' : null
				}
			]
		},
		{ 
			"name" : "double punch",
			"card_target" : 'enemy',
			"effect" : "attack",
			"cost" : 1,
			"description" : 'Does 5 damage twice.',
			"actions" : [
				{
					'action_name' : 'attack',
					"effect" : "attack",
					'description' : '',
					'priority' : 'fast',
					'trigger' : null,
					'multiplier' : null,
					'turn' : 0,
					'duration' : 1,
					'attribute' : 'health',
					'target' : 'single',
					'value_min' : 3,
					'value_max' : 3,
					'status' : null
					
				},
				{
					'action_name' : 'attack',
					"effect" : "attack",
					'description' : '',
					'priority' : 'fast',
					'trigger' : null,
					'multiplier' : null,
					'turn' : 0,
					'duration' : 1,
					'attribute' : 'health',
					'target' : 'single',
					'value_min' : 3,
					'value_max' : 3,
					'status' : null
				}
			]
		},
		{ 
			"name" : "team heal",
			"card_target" : 'friend',
			"effect" : "attack",
			"cost" : 2,
			"description" : '',
			"actions" : [
				{
					'action_name' : 'attack',
					"effect" : "attack",
					'description' : 'Heals postle for 20 hp.',
					'priority' : 'fast',
					'trigger' : null,
					'multiplier' : null,
					'turn' : 0,
					'duration' : 1,
					'attribute' : 'health',
					'target' : 'single',
					'value_min' : 20,
					'value_max' : 20,
					'status' : null
				},
				{
					'action_name' : 'attack',
					"effect" : "attack",
					'description' : 'Heals main for 10 hp.',
					'priority' : 'fast',
					'trigger' : null,
					'multiplier' : null,
					'turn' : 0,
					'duration' : 1,
					'attribute' : 'health',
					'target' : 'single',
					'value_min' : 10,
					'value_max' : 10,
					'status' : null
				}
			]
		},
		{ 
			"name" : 'make vulnerable',
			"card_target" : 'enemy',
			"effect" : 'status',
			"cost" : 1,
			"description" : 'Gives enemy a 25% vulnerability.',
			"actions" : [
				{
					'action_name' : 'vulnerable',
					'effect' : 'status',
					'description' : '',
					'priority' : 'fast',
					'trigger' : null,
					'multiplier' : true,
					'turn' : 0,
					'duration' : 1,
					'attribute' : 'defense',
					'target' : 'single',
					'value_min' : 0.75,
					'value_max' : 0.75,
					'status' : null	
				}
			]
		}
	]