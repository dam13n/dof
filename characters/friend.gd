extends Area2D

var starting_health = 60
var health = 60
var front_row = true
var type = 'friend'

var overlapping_bodies = []
var is_hovering = false

var status_effects = []

var deck
var hand_pile = []
var draw_pile = []
var discard_pile = []
var hand

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


func show_hand():
	hand.clear_cards()
	for card in hand_pile:
		hand.add_card(card.to_data(), self)
		#hand.active_hand.append(card)
		hand.set_card_destinations()
		hand.organize()
	
func _process(delta):
	overlapping_bodies = get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		print("found object")
		var ovlb = overlapping_bodies[0]

		if is_hovering && ovlb.playable(self):
			var actions = ovlb.get_playable_actions(self)
			if actions.size() > 0:
				for action in actions:
					process_action(action)
					update_health()
					
				_check_alive()
			ovlb.remove()

func process_action(action):
	if action.target == 'card_target':
		if action.attribute == 'health':
	#		action.enemy_targeting['attribute']
			var value = int(rand_range(action.value_min, action.value_max)+0.5)
			health += value
			update_health()
		elif action.effect == 'status':
			print('effect is status')
			_add_status(action)
	elif action.target == 'card_owner':
		var card_owner = action.card_owner
		# this is a hackish way to stop an endless loop of trying to retarget card owner
		action.target = 'card_target'
		card_owner.process_action(action)
	
	
func reset_energy():
	update_energy()
	
func update_health():
	if health >= starting_health:
		health = starting_health
	$HP.text = "hp: " + str(health)
	$HealthBar.value = health
	if health <= 0:
		you_dead()

func you_dead():
	queue_free()
	
func _check_alive():
	if health <= 0:
		get_parent().queue_free()

func draw_hand():
	for card in draw_pile:
		hand_pile.append(card)
#	show_hand()

func prepare_deck_and_draw_pile():
	var deck_data = friend_deck.deck_data()

	for card_data in deck_data:
		
		var card_scene = load("res://cards/card.tscn")
		var card = card_scene.instance()
		
		card.card_owner = self
		card.card_name = card_data['name']
		card.target = card_data['card_target']
		card.effect = card_data['effect']

		card.cost = card_data['cost']
		card.description = card_data['description']
		for action_data in card_data['actions']:
			card.load_action(action_data)
		card.update_display()
		card.apply_scale(Vector2(0.25,0.25))
			
		draw_pile.append(card)
	draw_hand()
		
func _ready():
	hand = get_parent().get_node('Hand')
	prepare_deck_and_draw_pile()

	connect("mouse_entered", self, "_mouse_over", [true])
	connect("mouse_exited",  self, "_mouse_over", [false])

	update_health()
	$HealthBar.max_value = starting_health
	$HealthBar.min_value = 0

func _mouse_over(over):	
	if over == true:
		is_hovering = true
		$CharacterInfo.visible = true
	else:
		is_hovering = false
		$CharacterInfo.visible = false

func _input(event):
	if event is InputEventMouseButton && event.pressed && is_hovering == true:
		show_hand()
		
# may be useful later
#func _input(ev):
#    if ev.type == InputEvent.MOUSE_BUTTON:
#        if ev.pos > get_pos() && ev.pos < get_pos() + get_size():
#             #Do Things here, because mouse pointer is inside sprite