extends Node

var friends = []

func _ready():
	load_friends()
#	get_node('Deck').make_cards()
	
func load_friends():
	friends = []
	var player = get_node('Player')
	var postle = get_node('Friend')
	
	#check for deleted nodes
	if player != null:
		friends.append(player)
	if postle != null:
		friends.append(postle)

func next_turn():
	if friends.size() > 0:
		process_enemy_actions()
		process_slow_cards()
		for enemy in enemies():
			for status in enemy.status_effects:
				status.next_turn()
			enemy.clear_statuses()
			enemy.update_info_node()
		$Player.reset_energy()
		
		
func enemies():
	var enemies = []
	for container in $Mob.get_children():
		enemies.append(container.get_children()[0])
	return enemies
		
		
func process_slow_cards():
	for enemy_container in $Mob.get_children():
		enemy_container.get_children()[0].process_slow_cards()	
		
func process_enemy_actions():
	for enemy in $Mob.get_children():
		load_friends()
		var enemy_target = find_enemys_target(enemy)
		var damage = enemy.get_node('Enemy').stats.get_damage()
		var response = enemy_target.stats.inflict_damage(damage)
		if response.has('parry'):
			enemy.get_node('Enemy').stats.inflict_damage_pass(response['parry'])
		
func find_enemys_target(enemy):
	if front_row_friends(friends).size() > 0:
		return shuffled_friends(front_row_friends(friends)).front()
	else:
		return shuffled_friends(back_row_friends(friends)).front()
	
func shuffled_friends(some_friends):
	var shuffled_friends_array = []
	if some_friends.size() == 1:
		return some_friends
	else:
		var index_list = range(some_friends.size())
		for i in range(friends.size()):
			randomize()
			var x = randi()%index_list.size()
			shuffled_friends_array.append(some_friends[x])
			index_list.remove(x)
			
		return shuffled_friends_array
	
func front_row_friends(some_friends):
	var front_row_friends_array = []
	for friend in some_friends:
		if friend.stats.front_row:
			front_row_friends_array.append(friend)
	return front_row_friends_array
	
func back_row_friends(some_friends):
	var back_row_friends_array = []
	for friend in some_friends:
		if not friend.stats.front_row:
			back_row_friends_array.append(friend)
	return back_row_friends_array
	