extends "res://scripts/input/handlers/gamepad_handler.gd"

var bag
var player

func _init(bag, player):
    self.bag = bag
    self.player = player
    self.type = InputEvent.JOYSTICK_MOTION
    self.axis = Globals.get("platform_input/xbox_right_trigger")

func handle(event):
    if self.bag.game_state.game_in_progress && self.player.is_playing && self.player.is_alive:
        if event.value > 0.5:
            if not self.player.is_attack_on_cooldown:
                self.player.attack()
            self.player.is_attacking = true
        else:
            self.player.is_attacking = false