extends Node

var status_owner
var status_name = ''
var attribute = ''
var priority = null

var multiplier = false
var value_min 
var value_max
var duration = 1

# attribute types:
# health defense accuracy block attack

func next_turn():
  if status_name == 'quicken':
    pass
  elif status_name == 'strengthen':
    pass
    
  else:
    if status_name == 'poison':
        print('applying poison damage')
        status_owner.stats.inflict_damage_pass(value_min)
    duration -= 1
    if duration == 0:
      queue_free()
    
    