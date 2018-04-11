extends Node

#var allies = []

func _ready():
  pass
#  load_allies()
#	get_node('Deck').make_cards()
  
#func load_allies():
#  allies = []
#  var player = get_node('Player')
#  var friend = get_node('Friend')
#
#  #check for deleted nodes
#  if player != null:
#    allies.append(player)
#  if friend != null:
#    allies.append(friend)

func next_turn():
  reference.load_all()  
  if reference.allies.size() > 0:
    process_enemy_actions()
    process_slow_cards()
    
    for enemy in reference.enemies:
      for status in enemy.stats.status_effects:
        status.next_turn()
      enemy.stats.clear_statuses()
      enemy.stats.update_info_node()

    for friend in reference.allies:
      for status in friend.stats.status_effects:
        status.next_turn()
      friend.stats.clear_statuses()
      friend.stats.update_info_node()	
      
    $Player.reset_energy()
    reference.load_all()
    
    
    
#func enemies():
#  var enemies = []
#  for container in $Mob.get_children():
#    enemies.append(container.get_children()[0])
#  return enemies
    
    
func process_slow_cards():
  for enemy in reference.enemies:
    enemy.process_slow_cards()
#  for enemy_container in $Mob.get_children():
#    enemy_container.get_children()[0].process_slow_cards()	
    
func process_enemy_actions():
  for enemy in reference.enemies:
    enemy.process_turn()
    reference.load_all()
#  for enemy in $Mob.get_children():
#    enemy.get_node('Enemy').process_turn()

#		load_allies()
#		var enemy_target = find_enemys_target(enemy)
#		var damage = enemy.get_node('Enemy').stats.get_damage()
#		var response = enemy_target.stats.inflict_damage(damage)
#		if response.has('parry'):
#			enemy.get_node('Enemy').stats.inflict_damage_pass(response['parry'])
    
#func find_enemys_target(enemy):
#	if front_row_allies(allies).size() > 0:
#		return shuffled_allies(front_row_allies(allies)).front()
#	else:
#		return shuffled_allies(back_row_allies(allies)).front()
#
#func shuffled_allies(some_allies):
#	var shuffled_allies_array = []
#	if some_allies.size() == 1:
#		return some_allies
#	else:
#		var index_list = range(some_allies.size())
#		for i in range(allies.size()):
#			randomize()
#			var x = randi()%index_list.size()
#			shuffled_allies_array.append(some_allies[x])
#			index_list.remove(x)
#
#		return shuffled_allies_array
#
#func front_row_allies(some_allies):
#	var front_row_allies_array = []
#	for friend in some_allies:
#		if friend.stats.front_row:
#			front_row_allies_array.append(friend)
#	return front_row_allies_array
#
#func back_row_allies(some_allies):
#	var back_row_allies_array = []
#	for friend in some_allies:
#		if not friend.stats.front_row:
#			back_row_allies_array.append(friend)
#	return back_row_allies_array
  