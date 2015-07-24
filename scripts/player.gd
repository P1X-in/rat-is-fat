extends "res://scripts/moving_object.gd"

var is_playing = false
var is_alive = true

func _init(bag).(bag):
    self.bag = bag
    self.velocity = 4
    self.avatar = preload("res://scenes/player/player.xscn").instance()
    self.initial_position = Vector2(100, 100)
    self.body_part_head = self.avatar.get_node('head')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('footer')

func bind_gamepad(id):
    var gamepad = self.bag.input.devices['pad' + str(id)]
    gamepad.register_handler(preload("res://scripts/input/handlers/player_enter_game_gamepad.gd").new(self.bag, self))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_move_axis.gd").new(self.bag, self, 0))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_move_axis.gd").new(self.bag, self, 1))

func bind_keyboard_and_mouse():
    var keyboard = self.bag.input.devices['keyboard']
    keyboard.register_handler(preload("res://scripts/input/handlers/player_enter_game_keyboard.gd").new(self.bag, self))
    keyboard.register_handler(preload("res://scripts/input/handlers/player_move_key.gd").new(self.bag, self, 1, KEY_W, -1))
    keyboard.register_handler(preload("res://scripts/input/handlers/player_move_key.gd").new(self.bag, self, 1, KEY_S, 1))
    keyboard.register_handler(preload("res://scripts/input/handlers/player_move_key.gd").new(self.bag, self, 0, KEY_A, -1))
    keyboard.register_handler(preload("res://scripts/input/handlers/player_move_key.gd").new(self.bag, self, 0, KEY_D, 1))

func enter_game():
    self.is_playing = true
    self.spawn()

func spawn():
    self.is_alive = true
    self.is_processing = true
    self.bag.action_controller.game_board.add_child(self.avatar)
    self.avatar.set_pos(self.initial_position)
    self.bag.processing.register(self)

func die():
    self.is_alive = false
    self.is_processing = false
    self.despawn()