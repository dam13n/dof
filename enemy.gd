extends Area2D

var starting_health = 20
var health = 20
var overlapping_bodies = []
var is_hovering = false

var enemy_name = 'baddie'
var damage = 10
var type = 'enemy'

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
		print("overlapping body count: ", overlapping_bodies.size())
		var ovlb = overlapping_bodies[0]
	
		if is_hovering && ovlb.playable(self):
			var do_not_remove = false
			var actions = ovlb.get_playable_actions(self)


			if actions.size() > 0:
				
				for action in actions:
	#				health -= ovlb.damage
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
	if action.enemy_targeting['attribute'] == 'health':
#		action.enemy_targeting['attribute']
		var value = int(rand_range(action.enemy_targeting['value_min'],action.enemy_targeting['value_max'])+0.5)
		health -= value

func process_slow_cards():
	for card in $SlowCards.get_children():
		var actions = card.get_playable_actions(self)
		for action in actions:
			process_action(action)
			_update_health()
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
	else:
		is_hovering = false
