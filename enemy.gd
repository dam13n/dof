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
		print("found object")
		var ovlb = overlapping_bodies[0]

		if is_hovering == true && ovlb.enough_energy() && ovlb.grabbed == false && ovlb.active == true && ovlb.target == type:
			var actions = ovlb.get_playable_actions(self)
			if actions.size() > 0:
				for action in actions:
	#				health -= ovlb.damage
					process_action(action)
					_update_health()
					
				_check_alive()
			ovlb.remove()

func process_action(action):
	if action.enemy_targeting['attribute'] == 'health':
#		action.enemy_targeting['attribute']
		var value = int(rand_range(action.enemy_targeting['value_min'],action.enemy_targeting['value_max'])+0.5)
		health -= value
			
func _check_alive():
	if health <= 0:
		get_parent().queue_free()
		
func _mouse_over(over):
	if over == true:
		is_hovering = true
	else:
		is_hovering = false
