extends Node

var action_name
var description

var priority # e.g., 'fast', 'slow'
var attribute # e.g., 'health', 'defense', 'accuracy'
var trigger # e.g., 'attacked'
var multiplier # i.e., true if effect multiples or does a % effect
var turn # 0 for now, 1 for next turn
var duration # e.g. 2 means action happens/lasts for 2 turns

# main character targeting

# friend targeting

# enemy targeting
var enemy_targeting = {
	'attribute' : null,
	'target' : null,
	'value_min' : null,
	'value_max' : null,
	'status' : null
}
