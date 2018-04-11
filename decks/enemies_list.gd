extends Node

func enemies_data():
  return [
    {
      'name' : 'Cordybiceps',
      'enemy_type' : 'standard',
      'health' : 50,
      'image_path' : '',
      'abilities' : [
        { 
          'name' : 'Rep',
          'type' : 'attack',
          'card_target' : 'friend',
          'description' : 'Does 10-15 damage.',
          'notes' : '',
          
          'target_priorities' : ['poisoned', 'front', 'low health'],
          'target_restrictions' : [],

          'actions' : [
            {
              'action_name' : 'rep',
              'target' : 'card_target',
              'description' : '',
              'multiplier' : null,
              'turn' : 0,
              'duration' : 1,
              'attribute' : 'health',
              'value_min' : 10,
              'value_max' : 15,
              'effect' : 'attack'
            }
          ]
        },
        { 
          'name' : 'Deathcap',
          'type' : 'special',
          'card_target' : 'friend',
          'description' : 'Poisons.',
          'notes' : '',
          
          'target_priorities' : ['front'],
          'target_restrictions' : [],

          'actions': [
            {
              'action_name' : 'deathcap - attack',
              'target' : 'card_target',
              'description' : '',
              'multiplier' : null,
              'turn' : 0,
              'duration' : 1,
              'attribute' : 'health',
              'value_min' : 15,
              'value_max' : 25,
              'effect' : 'attack'
            },
            {
              'action_name' : 'poison',
              'target' : 'card_target',
              'description' : '',
              'multiplier' : null,
              'turn' : 0,
              'duration' : 3,
              'attribute' : '',
              'value_min' : 5,
              'value_max' : 5,
              'effect' : 'status',
              'status' : 'poison'
            }
          ]
        },
      ]
    }
  ]
