extends Node

var world

var main
var player
var allies = []
var friends = []
var enemies = []

func _ready():
	world = get_parent().get_node('World')

	load_player()
	load_friends()
	load_allies()
	load_enemies()

func load_player():
  player = world.get_node('Player')
	
# strictly friends
func load_friends():
	friends.append(world.get_node('Friend'))

# friends + main character (i.e., player)
func load_allies():
  allies = friends + [player]

func load_enemies():
  enemies = []
  for container in world.get_node('Mob').get_children():
    enemies.append(container.get_children()[0])
  return enemies