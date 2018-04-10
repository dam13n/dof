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
          
          'target_priority' : ['poisoned', 'front', 'low health'],
          'target_restriction' : [],

          'actions' : [
            {
              'multiplier' : null,
              'turn' : 0,
              'duration' : 1,
              'attribute' : 'health',
              'value_min' : 10,
              'value_max' : 15,
              'status' : null
            }
          ]
        },
        { 
          'action_name' : 'Deathcap',
          'type' : 'special',
          'card_target' : 'friend',
          'description' : 'Poisons.',
          'notes' : '',
          
          'target_priority' : ['front'],
          'target_restriction' : [],

          'actions': [
            {
              'multiplier' : null,
              'turn' : 0,
              'duration' : 1,
              'attribute' : 'health',
              'value_min' : 15,
              'value_max' : 25,
              'status' : null
            },
            {
              'multiplier' : null,
              'turn' : 0,
              'duration' : 3,
              'attribute' : 'health',
              'value_min' : 5,
              'value_max' : 5,
              'status' : 'poison'
            }
          ]
        },
      ]
    }
  ]
