extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var overlapping_bodies = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func _physics_process(delta):
	overlapping_bodies = get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		print("found object")
		var ovlb = overlapping_bodies[0]
		if ovlb.grabbed == false:
			ovlb.queue_free()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
