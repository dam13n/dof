extends Node

var character
var character_name = ''

var max_energy = 4
var energy = 4
var starting_health = 20
var health = 20

var damage = 10

var defense = 1.0
var strength = 0 
var weakness = 1.0

var front_row = true

func get_weakness():
	for status in character.status_effects:
		if status.status_name == 'weakness':
			return status.value_min
	return weakness
	
func get_strength():
	for status in character.status_effects:
		if status.status_name == 'strength':
			return status.value_min
	return strength
	
func get_damage():
	# add strength modifier to damage
	var damage_temp = damage + strength
	# apply weakness
	damage_temp = (1-(1-get_weakness())) * damage_temp
	
	return damage_temp

func inflict_damage(base_damage):
	base_damage = (1+(1-get_defense())) * base_damage
	health -= base_damage
	character.update_health()

func get_defense():
	for status in character.status_effects:
		if status.status_name == 'vulnerability':
			return status.value_min
	return defense