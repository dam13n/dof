extends Node

func next_turn():
	for enemy in $Mob.get_children():
		$Player.health -= enemy.get_node('Enemy').damage
		$Player.update_health()
