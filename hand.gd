extends HBoxContainer

var width
var active_hand

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	width = get_size().x
	active_hand = get_children()
	set_card_destinations()
	organize()
	
func discard_cards():
	for card in active_hand:		
		card.queue_free()
	active_hand = []
	
func set_card_destinations():
	for i in range(0, active_hand.size()):
		var child = active_hand[i]
		var pos_x = width/(active_hand.size()+1)*(i+1)
		child.destination = Vector2(pos_x, 0)

func organize():
	for i in range(0, active_hand.size()):
		var child = active_hand[i]
		child.reset_position()
#		print('child count:', active_hand.size())
		
func remove_card(card):
#	print('removing card')
	var card_index = active_hand.find(card)
	active_hand.remove(card_index)
	set_card_destinations()
	organize()

