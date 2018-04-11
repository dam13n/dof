extends HBoxContainer



var enemy_1_count = 0

func spawn(type):
  print('spawn enemy')
  enemy_1_count += 1
  var mc = MarginContainer.new()
  mc.rect_min_size = Vector2(250,70)
  add_child(mc)
  var enemy_scene = load("res://characters/enemy.tscn")
  var enemy = enemy_scene.instance()
#	enemy.get_node('EnemyShape').get_node('Name').text = 'baddie ' + str(enemy_1_count)
  mc.add_child(enemy)
  
  connect("mouse_exited",  self, "_mouse_over", [false])
  reference.load_enemies()