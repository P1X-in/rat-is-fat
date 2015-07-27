extends "res://scripts/input/handlers/gamepad_handler.gd"

var bag
var player

func _init(bag, player):
    self.bag = bag
    self.player = player
    self.type = InputEvent.JOYSTICK_BUTTON
    self.button_index = Globals.get("platform_input/xbox_start")

func handle(event):
    if event.is_pressed() && self.bag.game_state.game_in_progress && not self.player.is_playing:
        self.player.enter_game()