extends Area2D

var starting_health = 20
var health = 20
var overlapping_bodies = []
var is_hovering = false

var enemy_name = 'baddie'
var damage = 10
var defense = 1 # base defense
var type = 'enemy'

var status_effects = []

func _ready():
	connect("mouse_entered", self, "_mouse_over", [true])
	connect("mouse_exited",  self, "_mouse_over", [false])
	_update_health()
	$EnemyShape/HealthBar.max_value = starting_health
	$EnemyShape/HealthBar.min_value = 0	

func _update_health():
	$EnemyShape/HP.text = "hp: " + str(health)
	$EnemyShape/HealthBar.value = health

func _process(delta):
	overlapping_bodies = get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
#		print("overlapping body count: ", overlapping_bodies.size())
		var ovlb = overlapping_bodies[0]
	
		if is_hovering && ovlb.playable(self):
			var do_not_remove = false
			var actions = ovlb.get_playable_actions(self)


			if actions.size() > 0:
				print('actioning')
				for action in actions:
					if action.priority == 'fast':
						process_action(action)
						_update_health()
					elif action.priority == 'slow':
						ovlb.move_to_destination = false
						ovlb.active = false
						do_not_remove = true
						

					
				_check_alive()
			if do_not_remove:
				ovlb.scale_for_slow_card()
				ovlb.get_parent().remove_card(ovlb)
				ovlb.get_parent().remove_child(ovlb)
				var detection_area = ovlb.get_node('DetectionArea')
				detection_area.disabled = true
				$SlowCards.add_child(ovlb)
				
#				ovlb.move_to_destination = false
				var slow_cards_count = $SlowCards.get_children().size()
				ovlb.position = Vector2((slow_cards_count-1)*10,0)
				ovlb.z_index = slow_cards_count
				print('do not remove')
			else:
				ovlb.remove()

func process_action(action):
	print('process_action: ', action.effect)
	if action.attribute == 'health':
		var current_defense = get_defense()
		var value = int(rand_range(action.value_min, action.value_max)+0.5)
		value = (1+(1-current_defense))*value
		health -= value
	elif action.effect == 'status':
		print('effect is status')
		_add_status(action)
		
func _add_status(action):
	var status_already_applied = false
	for status in status_effects:
		if status.status_name == action.action_name:
			status_already_applied = true
			status.duration += action.duration
	
	if not status_already_applied:
		var status_scene = load("res://status_effects.tscn")
		var status = status_scene.instance()
		status.attribute = action.attribute
		status.value_min = action.value_min
		status.value_max = action.value_max
		status.status_name = action.action_name
		status_effects.append(status)
	update_info_node()
	

func update_info_node():
	$CharacterInfo.get_node('Statuses').text = ''
	for status in status_effects:
		$CharacterInfo.get_node('Statuses').text += str(status.duration) + ' ' + status.status_name
		
func clear_statuses():
	for status in status_effects:
		if status.duration == 0:
			status_effects.erase(status)
	
func get_defense():
	for status in status_effects:
		if status.status_name == 'vulnerable':
			print('vulned')
			return status.value_min
		
	return defense


func process_slow_cards():
	for card in $SlowCards.get_children():
		var actions = card.get_playable_actions(self)
		for action in actions:
			process_action(action)
			_update_health()
		$SlowCards.remove_child(card)
		card.remove()
	_check_alive()
			
func _check_alive():
	if health <= 0:
		# free up all tree (to take care of slow cards)
		propagate_call("queue_free", [])
		
		# free parent holder
		get_parent().queue_free()
		
func _mouse_over(over):
	if over == true:
		is_hovering = true
		$CharacterInfo.visible = true
	else:
		is_hovering = false
		$CharacterInfo.visible = false