extends Button

func _ready():
  connect("button_up", self, "button_released")

func button_released():
  reference.load_all()
  reference.hand.discard_cards()
  reference.world.next_turn()