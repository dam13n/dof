extends Node

var action_name
var description

var priority # e.g., 'fast', 'slow'

var trigger # e.g., 'attacked'
var multiplier # i.e., true if effect multiples or does a % effect
var turn # 0 for now, 1 for next turn
var duration # e.g. 2 means action happens/lasts for 2 turns

var attribute # e.g., 'health', 'defense', 'accuracy'
var target
var value_min
var value_max
var effect
#
## main character targeting
#var main_targeting = {
#	'attribute' : null,
#	'target' : null,
#	'value_min' : null,
#	'value_max' : null,
#	'status' : null
#}
#
## friend targeting
#var friend_targeting = {
#	'attribute' : null,
#	'target' : null,
#	'value_min' : null,
#	'value_max' : null,
#	'status' : null
#}
#
## enemy targeting
#var enemy_targeting = {
#	'attribute' : null,
#	'target' : null,
#	'value_min' : null,
#	'value_max' : null,
#	'status' : null
#}
