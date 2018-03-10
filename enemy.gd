extends Area2D

var starting_health = 20
var health = 20
var overlapping_bodies = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	_update_health()
	$EnemyShape/HealthBar.max_value = starting_health
	$EnemyShape/HealthBar.min_value = 0	

func _update_health():
	$EnemyShape/HP.text = "hp: " + str(health)
	$EnemyShape/HealthBar.value = health
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	overlapping_bodies = get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		print("found object")
		var ovlb = overlapping_bodies[0]

		if ovlb.grabbed == false && ovlb.active == true:
			health -= ovlb.damage
			_update_health()
			ovlb.remove()
			_check_alive()
			
func _check_alive():
	if health <= 0:
		queue_free()
