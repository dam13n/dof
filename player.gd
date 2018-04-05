extends Area2D

var starting_health = 60
var health = 60
var max_energy = 4
var energy = 4
var front_row = true

var is_hovering = false

var status_effects = []

var deck
var hand_pile = []
var draw_pile = []
var discard_pile = []
var hand

func _ready():
	hand = get_parent().get_node('Hand')
	prepare_deck_and_draw_pile()
	
	connect("mouse_entered", self, "_mouse_over", [true])
	connect("mouse_exited",  self, "_mouse_over", [false])
	update_health()
	$PlayerShape/HealthBar.max_value = starting_health
	$PlayerShape/HealthBar.min_value = 0
	update_energy()


func reset_energy():
	energy = max_energy
	update_energy()
	
func update_health():
	$PlayerShape/HP.text = "hp: " + str(health)
	$PlayerShape/HealthBar.value = health
	if health <= 0:
		you_dead()

func you_dead():
	print('dead')
	
func update_energy():
	$PlayerShape/Energy.text = "Energy: " + str(energy)
	
func _check_alive():
	if health <= 0:
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

func draw_hand():
	for card in draw_pile:
		hand_pile.append(card)
	show_hand()

func show_hand():
	hand.clear_cards()
	for card in hand_pile:
		hand.add_child(card)
		hand.active_hand.append(card)
		hand.set_card_destinations()
		hand.organize()

func prepare_deck_and_draw_pile():
	var deck_data = player_deck.deck_data()

	for card_data in deck_data:
		
		var card_scene = load("res://cards/card2.tscn")
		var card = card_scene.instance()

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
	
		
# may be useful later
#func _input(ev):
#    if ev.type == InputEvent.MOUSE_BUTTON:
#        if ev.pos > get_pos() && ev.pos < get_pos() + get_size():
#             #Do Things here, because mouse pointer is inside sprite