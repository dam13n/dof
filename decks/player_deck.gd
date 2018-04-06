extends Node

func deck_data():
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