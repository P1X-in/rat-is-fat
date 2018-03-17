extends "res://scripts/input/handlers/gamepad_handler.gd"

var bag
var player
var direction

func _init(bag, player, axis, key, direction):
    self.bag = bag
    self.player = player
    self.axis = axis
    self.direction = direction
    self.type = InputEvent.JOYSTICK_BUTTON
    self.button_index = key

func handle(event):
    if self.bag.game_state.game_in_progress && self.player.is_playing && self.player.is_alive:
        #self.player.target_cone_vector[0] = 0
        #self.player.target_cone_vector[1] = 0
        #self.player.target_cone_vector[self.axis] = self.direction

        if abs(self.player.movement_vector[0]) > 0 or abs(self.player.movement_vector[1]) > 0:
            self.player.target_cone_vector[0] = self.player.movement_vector[0]
            self.player.target_cone_vector[1] = self.player.movement_vector[1]
