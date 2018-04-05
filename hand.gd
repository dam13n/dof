extends HBoxContainer

var width
var active_hand = []

func _ready():
	width = get_size().x
#	active_hand = get_children()
#	set_card_destinations()
#	organize()

func clear_cards():
	for child in get_children():
		remove_child(child)
	
#func discard_cards():
#	for card in active_hand:		
#		card.queue_free()
#	active_hand = []
	
func set_card_destinations():
	for i in range(0, get_children().size()):
		var child = get_children()[i]
		var pos_x = width/(get_children().size()+1)*(i+1)
		child.destination = Vector2(pos_x, 0)

func organize():
	print('active hand size: ', get_children().size())
	for i in range(0, get_children().size()):
		var child = get_children()[i]
		child.reset_position()
#		print('child count:', get_children().size())
		
func remove_card(card):
#	print('removing card')
	var card_index = active_hand.find(card)
	active_hand.remove(card_index)
	set_card_destinations()
	organize()

