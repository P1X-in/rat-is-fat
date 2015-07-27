extends "res://scripts/input/handlers/gamepad_handler.gd"

var bag
var player

var reverse

func _init(bag, player):
    self.bag = bag
    self.player = player
    self.type = InputEvent.JOYSTICK_MOTION
    self.axis = Globals.get("platform_input/xbox_right_trigger")
    self.reverse = Globals.get("platform_input/xbox_reverse_trigger")

func handle(event):
    if self.bag.game_state.game_in_progress && self.player.is_playing && self.player.is_alive:
        if (not self.reverse && event.value > 0.5) || (self.reverse && event.value < -0.25):
            self.player.is_attacking = true
            self.player.attack()
        else:
            self.player.is_attacking = false