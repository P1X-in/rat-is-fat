extends "res://scripts/moving_object.gd"

var bag
var player_avatar = preload("res://scenes/player/player.xscn").instance()

var is_playing = false
var is_alive = true

func _init(bag):
    self.bag = bag
    self.speed = 10

func bind_gamepad(id):
    self.bag.input.devices['pad' + str(id)].register_handler(preload("res://scripts/input/handlers/player_enter_game_gamepad.gd").new(self.bag, self))

func enter_game():
    self.is_playing = true
    self.spawn()
    self.player_avatar.set_pos(Vector2(100, 100))

func spawn():
    self.is_alive = true
    self.bag.action_controller.game_board.add_child(self.player_avatar)

func despawn():
    self.bag.action_controller.game_board.remove_child(self.player_avatar)

func die():
    self.is_alive = false
    self.despawn()