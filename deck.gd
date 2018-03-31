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
		card.target = card_data['target']
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
			"target" : 'enemy',
			"effect" : "attack",
			"cost" : 2,
			"description" : '',
			"actions" : [
				{
					'action_name' : 'attack',
					'description' : 'Does 10-20 damage. ',
					'priority' : 'slow',
					'trigger' : null,
					'multiplier' : null,
					'turn' : 0,
					'duration' : 1,
					'enemy_targeting' : {
						'attribute' : 'health',
						'target' : 'single',
						'value_min' : 10,
						'value_max' : 20,
						'status' : null
					}	
					
				}
			]
		},
		{ 
			"name" : "double punch",
			"target" : 'enemy',
			"effect" : "attack",
			"cost" : 1,
			"description" : 'Does 5 damage twice.',
			"actions" : [
				{
					'action_name' : 'attack',
					'description' : '',
					'priority' : 'fast',
					'trigger' : null,
					'multiplier' : null,
					'turn' : 0,
					'duration' : 1,
					'enemy_targeting' : {
						'attribute' : 'health',
						'target' : 'single',
						'value_min' : 5,
						'value_max' : 5,
						'status' : null
					}	
					
				},
				{
					'action_name' : 'attack',
					'description' : '',
					'priority' : 'fast',
					'trigger' : null,
					'multiplier' : null,
					'turn' : 0,
					'duration' : 1,
					'enemy_targeting' : {
						'attribute' : 'health',
						'target' : 'single',
						'value_min' : 5,
						'value_max' : 5,
						'status' : null
					}	
					
				}
			]
		},
		{ 
			"name" : "team heal",
			"target" : 'friend',
			"effect" : "attack",
			"cost" : 2,
			"description" : '',
			"actions" : [
				{
					'action_name' : 'attack',
					'description' : 'Heals postle for 20 hp.',
					'priority' : 'fast',
					'trigger' : null,
					'multiplier' : null,
					'turn' : 0,
					'duration' : 1,
					'friend_targeting' : {
						'attribute' : 'health',
						'target' : 'single',
						'value_min' : 20,
						'value_max' : 20,
						'status' : null
					}	
					
				},
				{
					'action_name' : 'attack',
					'description' : 'Heals main for 10 hp.',
					'priority' : 'fast',
					'trigger' : null,
					'multiplier' : null,
					'turn' : 0,
					'duration' : 1,
					'main_targeting' : {
						'attribute' : 'health',
						'target' : 'single',
						'value_min' : 10,
						'value_max' : 10,
						'status' : null
					}	
					
				}
			]
		}
	]
	
	
	
#func get_deck_data():
#	return [
#		{ 
#			"name" : "slash",
#			"effect" : "attack",
#			"cost" : 2,
#			"damage" : 10
#		},
#		{ 
#			"name" : "bite",
#			"effect" : "attack",
#			"cost" : 1,
#			"damage" : 5
#		},
#		{ 
#			"name" : "poke",
#			"effect" : "attack",
#			"cost" : 1,
#			"damage" : 3
#		},
#		{ 
#			"name" : "defenestrate",
#			"effect" : "attack",
#			"cost" : 3,
#			"damage" : 15
#		},
#		{ 
#			"name" : "eviscerate",
#			"effect" : "attack",
#			"cost" : 2,
#			"damage" : 11
#		}
#	]

