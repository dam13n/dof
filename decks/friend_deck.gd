extends Node

func deck_data():
  return [
    { 
      "name" : "thwoppp",
      "card_target" : 'enemy',
      "effect" : "attack",
      "cost" : 1,
      "description" : '',
      "actions" : [
        {
          'action_name' : 'attack',
          "effect" : "attack",
          'description' : 'Does 5-10 damage. ',
          'priority' : 'fast',
          'trigger' : null,
          'multiplier' : null,
          'turn' : 0,
          'duration' : 1,
          'attribute' : 'health',
          'target' : 'card_target',
          'value_min' : 5,
          'value_max' : 10,
          'status' : null
        }
      ]
    },
    { 
      "name" : "thwoppp",
      "card_target" : 'enemy',
      "effect" : "attack",
      "cost" : 1,
      "description" : '',
      "actions" : [
        {
          'action_name' : 'attack',
          "effect" : "attack",
          'description' : 'Does 5-10 damage. ',
          'priority' : 'fast',
          'trigger' : null,
          'multiplier' : null,
          'turn' : 0,
          'duration' : 1,
          'attribute' : 'health',
          'target' : 'card_target',
          'value_min' : 5,
          'value_max' : 10,
          'status' : null
        }
      ]
    }
  ]