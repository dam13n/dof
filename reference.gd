extends Node

var world

var main
var player
var allies = []
var friends = []
var enemies = []

func _ready():
  world = get_parent().get_node('World')
  load_all()

func load_player():
  player = world.get_node('Player')
  
# strictly friends
func load_friends():
  friends = []
  if world.get_node('Friend') != null:
    friends.append(world.get_node('Friend'))

# friends + main character (i.e., player)
func load_allies():
  allies = []
  allies = friends + [player]
  print('reference allies: ', allies)

func load_enemies():
  enemies = []
  for container in world.get_node('Mob').get_children():
    if container.get_children()[0] != null:
      enemies.append(container.get_children()[0])
  return enemies
  
#func load_enemies():
#  var enemies_temp = []
#  for container in world.get_node('Mob').get_children():
#    enemies_temp.append(container.get_children()[0])
#  enemies = enemies_temp
  
func load_all():
  load_player()
  load_friends()
  load_allies()
  load_enemies()