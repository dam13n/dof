	extends Area2D

var type = 'main'
var stats
var status_effects = []

var overlapping_bodies = []
var is_hovering = false

var deck
var hand_pile = []
var draw_pile = []
var discard_pile = []
var hand

func add_test_status():
	var status_scene = load("res://characters/status_effects.tscn")
	var status = status_scene.instance()
	status.status_name = 'quicken'
	status_effects.append(status)
	
	var status2 = status_scene.instance()
	status2.status_name = 'quicken'
	status_effects.append(status2)

func set_stats():
	stats.character_name = 'main'
	stats.max_energy = 4
	stats.energy = 4
	
	stats.starting_health = 80
	stats.health = 80
	stats.defense = 1 # base defense
	
	stats.front_row = true

func process_action(action):
	if action.target == 'card_target':
		if action.attribute == 'health':
			var base_damage = int(rand_range(action.value_min, action.value_max)+0.5)
			stats.inflict_damage(base_damage)
		elif action.effect == 'status':
			print('effect is status')
			_add_status(action)
			
	elif action.target == 'card_owner':
		var card_owner = action.card_owner
		# this is a hackish way to stop an endless loop of trying to retarget card owner
		action.target = 'card_target'
		card_owner.process_action(action)

func draw_hand():
	for card in draw_pile:
		hand_pile.append(card)
	show_hand()

func show_hand():
	hand.clear_cards()
	for card in hand_pile:
		hand.add_card(card.to_data(), self)
		#hand.active_hand.append(card)
		hand.set_card_destinations()
		hand.organize()

func prepare_deck_and_draw_pile():
	var deck_data = player_deck.deck_data()
	for card_data in deck_data:
		var card = make_card(card_data)
		draw_pile.append(card)
	draw_hand()

func make_card(card_data):
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

		return card
	
func _ready():
	add_test_status()
	
	hand = get_parent().get_node('Hand')
	prepare_deck_and_draw_pile()
	
	connect("mouse_entered", self, "_mouse_over", [true])
	connect("mouse_exited",  self, "_mouse_over", [false])
	var stats_scene = load("res://characters/stats.tscn")
	stats = stats_scene.instance()
	stats.character = self
	set_stats()
	
	$PlayerShape/HealthBar.max_value = stats.starting_health
	$PlayerShape/HealthBar.min_value = 0	
	update_health()

	update_energy()
	


func reset_energy():
	stats.energy = stats.max_energy
	update_energy()
	
func update_health():
	$PlayerShape/HP.text = "hp: " + str(stats.health)
	$PlayerShape/HealthBar.value = stats.health
	if stats.health <= 0:
		you_dead()

func you_dead():
	print('dead')
	
func update_energy():
	$PlayerShape/Energy.text = "Energy: " + str(stats.energy)
	
func _check_alive():
	if stats.health <= 0:
		get_parent().queue_free()

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