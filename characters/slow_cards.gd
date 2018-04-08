extends HBoxContainer

var width
var slow_cards = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	width = get_size().x
	
func discard_cards():
	for card in slow_cards:		
		card.queue_free()
	slow_cards = []
	
func set_card_destinations():
	for i in range(0, slow_cards.size()):
		var child = slow_cards[i]
		var pos_x = width/(slow_cards.size()+1)*(i+1)
		child.destination = Vector2(pos_x, 0)