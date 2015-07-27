extends "res://scripts/input/handlers/gamepad_handler.gd"

var bag
var player
var index

var AXIS_THRESHOLD = 0.15

func _init(bag, player, index, axis):
    self.bag = bag
    self.player = player
    self.type = InputEvent.JOYSTICK_MOTION
    self.axis = axis
    self.index = index

func handle(event):
    if self.bag.game_state.game_in_progress && self.player.is_playing && self.player.is_alive && abs(event.value) > self.AXIS_THRESHOLD:
        self.player.target_cone_vector[self.index] = event.value