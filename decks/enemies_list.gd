extends Node

func enabled_enemies_data():
  var enabled_enemies_data_array = []
  for enemy in enemies_data():
    if enemy['enabled']:
      enabled_enemies_data_array.append(enemy)
  return enabled_enemies_data_array

func enemies_data():
  return [
    {
      'enabled' : true,
      'name' : 'Pitcher Plant',
      'enemy_type' : 'standard',
      'health' : 75,
      'image_path' : 'Pitcher_Plant.png',
      'abilities' : [
        { 
          'name' : 'Trip',
          'type' : 'attack',
          'card_target' : 'friend',
          'description' : 'Does 10-15 damage.',
          'notes' : '',
          
          'target_priorities' : [['card played','slow'], ['row', 'front']],
          'target_restrictions' : [],

          'actions' : [
            {
              'action_name' : 'whip',
              'target' : 'card_target',
              'description' : '',
              'multiplier' : null,
              'turn' : 0,
              'duration' : 1,
              'attribute' : 'health',
              'value_min' : 10,
              'value_max' : 15,
              'effect' : 'attack'
            },
            {
              'action_name' : 'remove slow card',
              'target' : 'card_owner',
              'description' : '',
              'multiplier' : true,
              'turn' : 0,
              'duration' : 1,
              'attribute' : 'health',
              'value_min' : 0.50,
              'value_max' : 0.50,
              'effect' : 'remove slow card'
            }
          ]
        },
        { 
          'name' : 'Acid Spew',
          'type' : 'special',
          'card_target' : 'friend',
          'description' : 'Does 15-25 damage.',
          'notes' : '',
          
          'target_priorities' : [['card played','any'], ['row', 'back']],
          'target_restrictions' : [],

          'actions' : [
            {
              'action_name' : 'damage',
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
              'action_name' : "remove card",
              'target' : 'card_target',
              'description' : '',
              'multiplier' : null,
              'turn' : 0,
              'duration' : 1,
              'attribute' : null,
              'value_min' : null,
              'value_max' : null,
              'effect' : "remove an ally's played card"
            }
          ]
        }
      ]
    },
    {
      'enabled' : true,
      'name' : 'Astral Jelly',
      'enemy_type' : 'standard',
      'health' : 80,
      'image_path' : 'astral-jelly.png',
      'abilities' : [
        { 
          'name' : 'Tentacle Whip',
          'type' : 'attack',
          'card_target' : 'friend',
          'description' : 'Does 20-30 damage.',
          'notes' : '',

          'target_priorities' : [['row','back'], ['health', 'lowest']],
          'target_restrictions' : [],

          'actions' : [
            {
              'action_name' : 'whip',
              'target' : 'card_target',
              'description' : '',
              'multiplier' : null,
              'turn' : 0,
              'duration' : 1,
              'attribute' : 'health',
              'value_min' : 20,
              'value_max' : 30,
              'effect' : 'attack'
            }
          ]
        },
        { 
          'name' : 'Spin Cycle',
          'type' : 'special',
          'card_target' : 'allies',
          'description' : 'Does 20-25 damage.',
          'notes' : '',

          'target_priorities' : [],
          'target_restrictions' : [],

          'actions' : [
            {
              'action_name' : 'spin',
              'target' : 'card_target',
              'description' : '',
              'multiplier' : null,
              'turn' : 0,
              'duration' : 1,
              'attribute' : 'health',
              'value_min' : 20,
              'value_max' : 25,
              'effect' : 'attack'
            }
          ]
        }
      ]
    },
    {
      'enabled' : true,
      'name' : 'Cordybiceps',
      'enemy_type' : 'standard',
      'health' : 50,
      'image_path' : 'cordyceps-testosterone.jpg',
      'abilities' : [
        { 
          'name' : 'Rep',
          'type' : 'attack',
          'card_target' : 'friend',
          'description' : 'Does 10-15 damage.',
          'notes' : '',

          'target_priorities' : [['effect','poison'], ['row','front'], ['health', 'lowest']],
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
        { 
          'name' : 'Sporeburst',
          'type' : 'special',
          'card_target' : 'allies',
          'description' : 'Poisons all.',
          'notes' : '',

          'target_priorities' : [],
          'target_restrictions' : [],

          'actions': [
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
        }
      ]
    }
  ]
