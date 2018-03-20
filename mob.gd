extends HBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var enemy_1_count = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func spawn(type):
	print('spawn enemy')
	enemy_1_count += 1
	var mc = MarginContainer.new()
	mc.rect_min_size = Vector2(250,70)
	add_child(mc)
	var enemy_scene = load("res://enemy.tscn")
	var enemy = enemy_scene.instance()
	enemy.get_node('EnemyShape').get_node('Name').text = 'baddie ' + str(enemy_1_count)
	mc.add_child(enemy)
	
