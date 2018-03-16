extends Area2D

var starting_health = 20
var health = 20
var overlapping_bodies = []
var enemy_name = 'baddie'
var damage = 10
var type = 'enemy'

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
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

		if ovlb.grabbed == false && ovlb.active == true:
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
