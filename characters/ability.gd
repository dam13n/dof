extends Node

var ability_owner
var ability_name
var type
var card_target #naming convention for consistency
var description
var notes
var target_priorities
var target_restrictions

var actions = []

func set_attributes(ability_data):
  ability_name = ability_data['name']
  type = ability_data['type']
  card_target = ability_data['card_target']
  description = ability_data['description']
  notes = ability_data['notes']
  target_priorities = ability_data['target_priorities']
  target_restrictions = ability_data['target_restrictions']

  for action_data in ability_data['actions']:
    load_action(action_data)

func load_action(action_data):
  var action_scene = load("res://cards/action.tscn")
  var action = action_scene.instance()
  
  action.action_name = action_data['action_name']
  action.description = action_data['description']
  action.target = action_data['target']
  
#  action.priority = action_data['priority']
#  action.trigger = action_data['trigger']
  action.multiplier = action_data['multiplier']
  action.turn = action_data['turn']
  action.duration = action_data['duration']
  action.attribute = action_data['attribute']
  action.effect  = action_data['effect']
  action.value_min = action_data['value_min']
  action.value_max = action_data['value_max']
  
  action.card_owner = ability_owner
  
  actions.append(action)