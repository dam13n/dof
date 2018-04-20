extends Button

func _ready():
  connect("button_up", self, "button_released")

func button_released():
  reference.load_all()
#  for ally in reference.allies:
#    ally.hand.clear_cards()
  reference.hand.discard_cards()
#  get_parent().get_node('Hand').clear_cards()
  reference.world.next_turn()