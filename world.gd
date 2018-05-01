extends Node

var enemy_banner_timer
var slow_card_banner_timer


func timer_function(function, duration):
  var timer = Timer.new()
  timer.set_one_shot(true)
  timer.set_wait_time(1)
  timer.connect("timeout", self, function)
  add_child(timer)
  timer.start()

func _ready():
  enemy_banner_timer = Timer.new()
  enemy_banner_timer.set_one_shot(true)
  enemy_banner_timer.set_wait_time(1)
  enemy_banner_timer.connect("timeout", self, "on_enemy_timeout_complete")
  add_child(enemy_banner_timer)

  slow_card_banner_timer = Timer.new()
  slow_card_banner_timer.set_one_shot(true)
  slow_card_banner_timer.set_wait_time(1)
  slow_card_banner_timer.connect("timeout", self, "on_slow_card_timeout_complete")
  add_child(slow_card_banner_timer)

func return_hand():
  for ally in reference.allies:
    reference.hand.return_cards()

func clear_hands():
  for ally in reference.allies:
    ally.deck_manager.hand.clear_cards()

func next_turn():
  reference.load_all()  
  if reference.allies.size() > 0:
    
    timer_function("process_enemy_actions", 1)
    timer_function("end_of_turn", 1)
#    enemy_banner_timer.start()

func enemy_banner():
  $EnemyTurnBanner.visible = true
  timer_function("on_enemy_timeout_complete", 1)
    
func on_slow_card_timeout_complete():
    $SlowCardTurnBanner.visible = false
    process_slow_cards()
    
func on_enemy_timeout_complete():
    $EnemyTurnBanner.visible = false
#    process_enemy_actions()
    
func end_of_turn():
    $SlowCardTurnBanner.visible = true
    slow_card_banner_timer.start()
    
    
    for enemy in reference.enemies:
      for status in enemy.stats.status_effects:
        status.next_turn()
      enemy.stats.clear_statuses()
      enemy.stats.update_info_node()

    for friend in reference.allies:
      for status in friend.stats.status_effects:
        status.next_turn()
      friend.stats.slow_card_played_this_turn = false
      friend.stats.card_played_this_turn = false
      friend.stats.clear_statuses()
      friend.stats.update_info_node()
      friend.deck_manager.discard_hand()
      friend.deck_manager.drawn_this_turn = false
      
    reference.player.reset_energy()
    reference.load_all()
    
    
func process_slow_cards():
  for enemy in reference.enemies:
    enemy.process_slow_cards()
    
func process_enemy_actions():
  for enemy in reference.enemies:
    enemy.process_turn()
    reference.load_all()

  