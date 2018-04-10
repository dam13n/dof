extends Node

var character
var character_name = ''

var max_energy = 4
var energy = 4
var starting_health = 20
var health = 20

var damage = 10

var defense = 1.0
var strength = 1.0
var weakness = 1.0
var block_chance = 0.05
#var accuracy = 1.0
var critical_chance = 0.05

var front_row = true

##########################################################
### block stuff
##########################################################
func get_block_chance():
	var block_temp = block_chance
	for status in character.status_effects:
		if status.status_name == 'block':
			block_temp += status.value_min
	return block_temp
	
func will_block():
	var roll = randi()%100+1
	if roll <= get_block_chance()*100:
		return true
	else:
		return false
		
func parry_damage():
	var parry = 0
	for status in character.status_effects:
		if status.status_name == 'parry':
			parry += status.value_min
	return parry
	
##########################################################

##########################################################
### accuracy stuff
##########################################################
func get_critical_chance():
	var critical_temp = critical_chance
	for status in character.status_effects:
		if status.status_name == 'accuracy':
			critical_temp += status.value_min
	return critical_temp
	
func will_critical():
	var roll = randi()%100+1
	if roll <= get_critical_chance()*100:
		return true
	else:
		return false
	
##########################################################

##########################################################
### quicken stuff
##########################################################
func quickened():
	var quicken_check = false
	for modifier in get_card_modifiers():
		if modifier == 'quicken':
			return true
	return false
	
func remove_quicken():
	for status in character.status_effects:
		if status.status_name == 'quicken':
			character.status_effects.erase(status)
			return
##########################################################

##########################################################
### strengthen stuff
##########################################################
func get_strength():
	var strength_temp = strength
	for status in character.status_effects:
		if status.status_name == 'strengthen':
			strength_temp += status.value_min
	return strength_temp

func strengthened():
	var strengthen_check = false
	for modifier in get_card_modifiers():
		if modifier == 'strengthen':
			return true
	return false
	
func remove_strengthen():
	for status in character.status_effects:
		if status.status_name == 'strengthen':
			character.status_effects.erase(status)
			return
##########################################################


func get_card_modifiers():
	var modifiers = []
	for status in character.status_effects:
			if status.status_name == 'quicken':
				modifiers.append('quicken')
	return modifiers

	
func get_damage():
	# add strength modifier to damage
	var damage_temp = damage + strength
	# apply weakness
	damage_temp = (1-(1-get_weakness())) * damage_temp
	
	return damage_temp

func inflict_damage(base_damage):
	var response = {}
	if will_block():
		print('blocked')
		var parry = parry_damage()
		if parry > 0:
			response['parry'] = parry
		
	else:
		base_damage = (1+(1-get_defense())) * base_damage
		health -= base_damage
		character.update_health()
	
	return response
	
# this inflict damage function passes any blocks, parries, etc. 
# for example, if you counter/parry, it can't be blocked or reparried, etc.
func inflict_damage_pass(base_damage):
	base_damage = (1+(1-get_defense())) * base_damage
	health -= base_damage
	character.update_health()

func get_defense():
	for status in character.status_effects:
		if status.status_name == 'vulnerability':
			return status.value_min
	return defense
	
#func get_accuracy():
#	for status in character.status_effects:
#		if status.status_name == 'accuracy':
#			return status.value_min
#	return accuracy
	
func get_weakness():
	for status in character.status_effects:
		if status.status_name == 'weakness':
			return status.value_min
	return weakness
	