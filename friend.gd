extends Area2D

var starting_health = 60
var health = 60
var front_row = true
var type = 'friend'

var overlapping_bodies = []
var is_hovering = false

func _ready():
	connect("mouse_entered", self, "_mouse_over", [true])
	connect("mouse_exited",  self, "_mouse_over", [false])
	update_health()
	$HealthBar.max_value = starting_health
	$HealthBar.min_value = 0
	
func _process(delta):
	overlapping_bodies = get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		print("found object")
		var ovlb = overlapping_bodies[0]

		if is_hovering && ovlb.playable(self):
			var actions = ovlb.get_playable_actions(self)
			if actions.size() > 0:
				for action in actions:
	#				health -= ovlb.damage
					process_action(action)
					update_health()
					
				_check_alive()
			ovlb.remove()

func process_action(action):
	if action.attribute == 'health':
#		action.enemy_targeting['attribute']
		var value = int(rand_range(action.value_min, action.value_max)+0.5)
		health += value
		update_health()
	
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

func _mouse_over(over):	
	if over == true:
		is_hovering = true
		$CharacterInfo.visible = true
	else:
		is_hovering = false
		$CharacterInfo.visible = false

func _input(event):
	if event is InputEventMouseButton && event.pressed && is_hovering == true:
		print('switch decks')
		
# may be useful later
#func _input(ev):
#    if ev.type == InputEvent.MOUSE_BUTTON:
#        if ev.pos > get_pos() && ev.pos < get_pos() + get_size():
#             #Do Things here, because mouse pointer is inside sprite