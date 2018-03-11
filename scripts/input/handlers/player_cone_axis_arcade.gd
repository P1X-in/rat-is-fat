extends "res://scripts/input/handlers/gamepad_handler.gd"

var bag
var player
var direction

func _init(bag, player, axis, direction):
    self.bag = bag
    self.player = player
    self.type = InputEvent.JOYSTICK_MOTION
    self.axis = axis
    self.direction = direction

func handle(event):
    if self.bag.game_state.game_in_progress && self.player.is_playing && self.player.is_alive:
        #var value = event.value
        #if self.axis == 1:
        #    value = -value
        #if value < -1:
        #    value = -1
        #if value > 1:
        #    value = 1
        #self.player.target_cone_vector[self.direction] = value

        if abs(self.player.movement_vector[0]) > 0 or abs(self.player.movement_vector[1]) > 0:
            self.player.target_cone_vector[0] = self.player.movement_vector[0]
            self.player.target_cone_vector[1] = self.player.movement_vector[1]
