extends Area2D

var type = 'enemy'
var enemy_type = 'standard'
var character_name = ''
var image_path = ''
var stats

var overlapping_bodies = []
var is_hovering = false

#var status_effects = []
var abilities = []

func set_stats():
#	var enemies_list_instance = load("res://decks/enemies_list.tscn").instance
    var enemies_data = enemies_list.enemies_data()

    randomize()
    var x = randi()%enemies_data.size()
    var enemy_data = enemies_data[x]

    character_name = enemy_data['name']
    enemy_type = enemy_data['enemy_type']
    image_path = enemy_data['image_path']
        
    stats.starting_health = enemy_data['health']
    stats.health = enemy_data['health']
#    stats.damage = 10
    stats.defense = 1 # base defense

    for ability_data in enemy_data['abilities']:
        var ability = load("res://characters/ability.tscn").instance()
        ability.ability_owner = self
        ability.set_attributes(ability_data)
        abilities.append(ability)

func _process(delta):
    overlapping_bodies = get_overlapping_bodies()
    if overlapping_bodies.size() > 0:
        var ovlb = overlapping_bodies[0]
    
        if is_hovering && ovlb.playable(self):
            var do_not_remove = false
            var actions = ovlb.get_playable_actions(self)

            if actions.size() > 0:
                var quickened = false
                if ovlb.card_owner.stats.quickened():
                    quickened = true
                    
                for action in actions:
                    if action.priority == 'fast':
                        stats.process_action(action)
                      
                    elif quickened:
                        ovlb.card_owner.stats.remove_quicken()
                        stats.process_action(action)
                        
                    elif action.priority == 'slow':
                        print('slow action played')
                        ovlb.move_to_destination = false
                        ovlb.active = false
                        do_not_remove = true
                    
                _check_alive()
            if do_not_remove:
                ovlb.scale_for_slow_card()
                ovlb.get_parent().remove_card(ovlb)
                ovlb.get_parent().remove_child(ovlb)
                var detection_area = ovlb.get_node('DetectionArea')
                detection_area.disabled = true
                $SlowCards.add_child(ovlb)
                
#				ovlb.move_to_destination = false
                var slow_cards_count = $SlowCards.get_children().size()
                ovlb.position = Vector2((slow_cards_count-1)*10,0)
                ovlb.z_index = slow_cards_count
                print('do not remove')
            else:
                ovlb.remove()

#func process_action(action):
#    print('process_action: ', action.effect)
#    if action.target == 'card_target':
#        if action.attribute == 'health':
##			var strengthened = false
##			if action.card_owner.stats.strengthened():
##				strengthened = true
#            var critical_damage_multiplier = 1.0
#            if action.card_owner.stats.will_critical():
#                print('will critical')
#                critical_damage_multiplier = 1.5
#            var base_damage = int(
#                (rand_range(action.value_min, action.value_max)+0.5)*
#                 action.card_owner.stats.get_strength()*
#                 critical_damage_multiplier
#              )
#            action.card_owner.stats.remove_strengthen()
#            stats.inflict_damage(base_damage)
#
#        elif action.effect == 'status':
#            print('effect is status')
#            _add_status(action)
#
#    update_health()
        
#func add_status(action):
#    var status_already_applied = false
#    for status in stats.status_effects:
#        if status.status_name == action.action_name:
#            status_already_applied = true
#            status.duration += action.duration
#
#    if not status_already_applied:
#        var status_scene = load("res://characters/status_effects.tscn")
#        var status = status_scene.instance()
#        status.attribute = action.attribute
#        status.value_min = action.value_min
#        status.value_max = action.value_max
#        status.status_name = action.action_name
#        status_effects.append(status)
#    update_info_node()
    
func update_display():
    get_node('EnemyShape').get_node('Name').text = character_name
    var imagetexture = ImageTexture.new()
    imagetexture.load("./images/" + image_path)
    $Sprite.set_texture(imagetexture)
    
func process_slow_cards():
    print($SlowCards.get_children())
    for card in $SlowCards.get_children():
        var actions = card.get_playable_actions(self)
        for action in actions:
            stats.process_action(action)
        $SlowCards.remove_child(card)
        card.remove()
    _check_alive()
    
func process_turn():
    var ability = choose_ability()
    print('enemy uses: ', ability.ability_name)
    
    if ability.card_target == 'allies':
      print('enemy targeting all allies')
      for ally in reference.allies:
        attack(ally)
    else:
      var enemy_target = choose_target(ability.target_priorities)
      attack(enemy_target)
    
func choose_target(target_priorities):
    reference.load_all()
    
    # implement later cuz complicated
    var potential_targets = []
    for x in range(target_priorities.size()):
      var target_priority = target_priorities[x]
      if target_priority[0] == 'effect':
        potential_targets.append([allies_with_effect(reference.allies, target_priority[1]), pow(10, (4-x))])
      elif target_priority[0] == 'row':
        potential_targets.append([allies_in_row(reference.allies, target_priority[1]), pow(10, (4-x))])
      elif target_priority[0] == 'health':
        potential_targets.append([allies_with_health(reference.allies, target_priority[1]), pow(10, (4-x))])
      elif target_priority[0] == 'card played':
        potential_targets.append([allies_with_card_played(reference.allies, target_priority[1]), pow(10, (4-x))])
      else:
        potential_targets.append([reference.allies, pow(10, (4-x))])

#    if potential_targets.empty():
    potential_targets.append([reference.allies, 1])

    var scored_potential_targets = score_potential_targets(potential_targets)
        
    var scored_potential_targets_array = []
    for ally in reference.allies:
      print('ally is: ', ally)
      scored_potential_targets_array.append([ally, scored_potential_targets[ally]])
    
    scored_potential_targets_array.sort_custom(AllySorter, 'score')
    return scored_potential_targets_array[0][0]
#    if front_row_allies(reference.allies).size() > 0:
#        return shuffled_allies(front_row_allies(reference.allies)).front()
#    else:
#        return shuffled_allies(back_row_allies(reference.allies)).front()

func score_potential_targets(potential_targets):
  var scored_potential_targets = {}
#  print('potential targets are: ', potential_targets)
  for targets in potential_targets:
#    print('targets are: ', targets)
    var score = targets[1]
    for target in targets[0]:
      if scored_potential_targets.has(target):
        scored_potential_targets[target] += score
      else:
        scored_potential_targets[target] = score
  print(scored_potential_targets)
  return scored_potential_targets

func attack(enemy_target):
#  var damage = stats.get_damage()
  var ability = choose_ability()
#  print(ability)
#    var response = enemy_target.stats.inflict_damage(damage)
#    if response.has('parry'):
#        stats.inflict_damage_pass(response['parry'])
  for action in ability.actions:
    #print(action)
    enemy_target.stats.process_action(action)
        
func choose_ability():
  var x = randi()%(abilities.size())
#  print('enemy ability choice index: ', x)
  var ability_choice = abilities[x]
  for status in stats.status_effects:
    if status.status_name == 'dazed':
      if ability_choice.type != 'attack':
        # we rechoose ability until we get a basic attack cuz dazed
        return choose_ability()
  return ability_choice
    
    
func shuffled_allies(some_allies):
    var shuffled_allies_array = []
    if some_allies.size() == 1:
        return some_allies
    else:
        var index_list = range(some_allies.size())
#        print('shuffled some_allies is:', some_allies)
        for i in range(reference.allies.size()):
            randomize()
            var x = randi()%index_list.size()
            shuffled_allies_array.append(some_allies[x])
            index_list.remove(x)
            
        return shuffled_allies_array
        
func allies_with_card_played(some_allies, speed):
  var allies_with_card_played_array = []
  for ally in reference.allies:
    if speed == 'slow':
      if ally.stats.slow_card_played_this_turn:
        allies_with_card_played_array.append(ally)
    elif speed == 'fast':
      if ally.stats.card_played_this_turn:
        allies_with_card_played_array.append(ally)
    elif speed == 'any':
      if ally.stats.card_played_this_turn || ally.stats.slow_card_played_this_turn:
        allies_with_card_played_array.append(ally)
  return allies_with_card_played_array
  
        
        
func allies_with_health(some_allies, superlative):
#  print('health check is: ', superlative)
#  print('the allies are: ', some_allies)
  some_allies.sort_custom(AllySorter, "health")
  if superlative == 'lowest':
    return [some_allies[0]]
  elif superlative == 'highest': 
    return [some_allies.invert()[0]]
  
class AllySorter:
  static func health(a, b):
#    print('a health: ', a.stats.health)
#    print('b health: ', b.stats.health)
    if a.stats.health < b.stats.health:
      return true
    return false
  static func score(a, b):
#    print('a score: ', a[1])
#    print('b score: ', b[1])
    if a[1] > b[1]:
      return true
    return false
        
func allies_with_effect(some_allies, effect):
  var allies_affected_array = []
  for ally in some_allies:
    if ally.stats.has_status(effect):
      allies_affected_array.append(ally)
  return allies_affected_array
  
func allies_in_row(some_allies, row):
  print('row check is: ', row)
  if row == 'front':
    return front_row_allies(some_allies)
  elif row == 'back':
    return back_row_allies(some_allies)
    
func front_row_allies(some_allies):
    var front_row_allies_array = []
#    print('front row some_allies is:', some_allies)
    for friend in some_allies:
        if friend.stats.front_row:
            front_row_allies_array.append(friend)
    return front_row_allies_array
    
func back_row_allies(some_allies):
    var back_row_allies_array = []
    for friend in some_allies:
        if not friend.stats.front_row:
            back_row_allies_array.append(friend)
    return back_row_allies_array
            
func _check_alive():
    if stats.health <= 0:
        # free up all tree (to take care of slow cards)
        propagate_call("queue_free", [])
        
        # free parent holder
        get_parent().queue_free()
        
func _ready():
    connect("mouse_entered", self, "_mouse_over", [true])
    connect("mouse_exited",  self, "_mouse_over", [false])

    var stats_scene = load("res://characters/stats.tscn")
    stats = stats_scene.instance()
    stats.character = self
    set_stats()
    
    
    
    $EnemyShape/HealthBar.max_value = stats.starting_health
    $EnemyShape/HealthBar.min_value = 0

    update_health()
    update_display()
    
func update_health():
    $EnemyShape/HP.text = "hp: " + str(stats.health)
    $EnemyShape/HealthBar.value = stats.health
        
func _mouse_over(over):
    if over == true:
        is_hovering = true
        $CharacterInfo.visible = true
    else:
        is_hovering = false
        $CharacterInfo.visible = false