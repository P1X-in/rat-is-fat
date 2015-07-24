extends "res://scripts/moving_object.gd"

var is_playing = false
var is_alive = true

func _init(bag).(bag):
    self.bag = bag
    self.velocity = 10
    self.avatar = preload("res://scenes/player/player.xscn").instance()

func bind_gamepad(id):
    var gamepad = self.bag.input.devices['pad' + str(id)]
    gamepad.register_handler(preload("res://scripts/input/handlers/player_enter_game_gamepad.gd").new(self.bag, self))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_move_axis.gd").new(self.bag, self, 0))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_move_axis.gd").new(self.bag, self, 1))

func enter_game():
    self.is_playing = true
    self.spawn()
    self.avatar.set_pos(Vector2(100, 100))

func spawn():
    self.is_alive = true
    self.is_processing = true
    self.bag.action_controller.game_board.add_child(self.avatar)

func despawn():
    self.bag.action_controller.game_board.remove_child(self.avatar)

func die():
    self.is_alive = false
    self.is_processing = false
    self.despawn()