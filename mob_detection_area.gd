extends Area2D

var type = 'enemies'

var overlapping_bodies = []
var is_hovering = false

var enemy_1_count = 0

func _process(delta):
  pass
#  overlapping_bodies = get_overlapping_areas()
#  if overlapping_bodies.size() > 0:
#    var ovlb = overlapping_bodies[0]
#
#    if is_hovering && ovlb.playable(self):
#      var do_not_remove = false
#      var actions = ovlb.get_playable_actions(self)
#
#      if actions.size() > 0:
#        for action in actions:
#          if action.priority == 'fast':
#            for enemy_container in get_parent().get_node('Mob').get_children():
#              if (enemy_container is MarginContainer):
#                # hacky temp fix
#                action.target = 'card_target'
#                enemy_container.get_children()[0].stats.process_action(action)
#          elif action.priority == 'slow':
#            ovlb.move_to_destination = false
#            ovlb.active = false
#            do_not_remove = true
#
#      if do_not_remove:
#        ovlb.scale_for_slow_card()
#        ovlb.get_parent().remove_card(ovlb)
#        ovlb.get_parent().remove_child(ovlb)
#        var detection_area = ovlb.get_node('DetectionArea')
#        detection_area.disabled = true
#        $SlowCards.add_child(ovlb)
#
##				ovlb.move_to_destination = false
#        var slow_cards_count = $SlowCards.get_children().size()
#        ovlb.position = Vector2((slow_cards_count-1)*10,0)
#        ovlb.z_index = slow_cards_count
#        print('do not remove')
#      else:
#        ovlb.remove()


func _mouse_over(over):
  if over == true:
    is_hovering = true
  else:
    is_hovering = false
  
func _ready():
  connect("mouse_entered", self, "_mouse_over", [true])
  connect("mouse_exited",  self, "_mouse_over", [false])