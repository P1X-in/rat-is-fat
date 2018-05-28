
var bag
var arcade = false

var devices = {
    "keyboard" : preload("res://scripts/input/keyboard.gd").new(),
    "mouse" : preload("res://scripts/input/mouse.gd").new(),
    "arcade" : preload("res://scripts/input/arcade.gd").new(),
    "pad0" : preload("res://scripts/input/gamepad.gd").new(0),
    "pad1" : preload("res://scripts/input/gamepad.gd").new(1),
    "pad2" : preload("res://scripts/input/gamepad.gd").new(2),
    "pad3" : preload("res://scripts/input/gamepad.gd").new(3)
}

func _init_bag(bag):
    self.bag = bag
    self.arcade = Globals.get('rif/arcade')
    self.load_basic_input()

func handle_event(event):
    self.bag.action_controller.idle_counter = 0
    for device in self.devices:
        if self.devices[device].can_handle(event):
            self.devices[device].handle_event(event)

func load_basic_input():
    self.devices['keyboard'].register_handler(preload("res://scripts/input/handlers/quit_game.gd").new())
    self.devices['keyboard'].register_handler(preload("res://scripts/input/handlers/start_game_key.gd").new(self.bag))
    if self.arcade:
        self.devices['arcade'].register_handler(preload("res://scripts/input/handlers/start_game_arcade.gd").new(self.bag, 14))
        self.devices['arcade'].register_handler(preload("res://scripts/input/handlers/start_game_arcade.gd").new(self.bag, 0))
        self.devices['arcade'].register_handler(preload("res://scripts/input/handlers/end_game_arcade.gd").new(self.bag))
        self.devices['arcade'].register_handler(preload("res://scripts/input/handlers/quit_game_arcade.gd").new(self.bag))
    else:
        self.devices['pad0'].register_handler(preload("res://scripts/input/handlers/start_game_gamepad.gd").new(self.bag))
        self.devices['pad1'].register_handler(preload("res://scripts/input/handlers/start_game_gamepad.gd").new(self.bag))
        self.devices['pad2'].register_handler(preload("res://scripts/input/handlers/start_game_gamepad.gd").new(self.bag))
        self.devices['pad3'].register_handler(preload("res://scripts/input/handlers/start_game_gamepad.gd").new(self.bag))
