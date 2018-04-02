extends Node

var status_name = ''
var attribute = ''
var priority = null

var multiplier = false
var value_min 
var value_max
var duration = 1

# attribute types:
# health defense accuracy block attack

func next_turn():
	duration -= 1
	if duration == 0:
		queue_free()
		
		