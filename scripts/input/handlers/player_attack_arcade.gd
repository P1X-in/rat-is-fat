extends "res://scripts/input/handlers/gamepad_handler.gd"

var bag
var player
var direction

func _init(bag, player, key):
    self.bag = bag
    self.player = player
    self.type = InputEvent.JOYSTICK_BUTTON
    self.button_index = key

func handle(event):
    if self.bag.game_state.game_in_progress && self.player.is_playing && self.player.is_alive:
        if event.is_pressed():
            self.player.attack()
        self.player.is_attacking = event.is_pressed()