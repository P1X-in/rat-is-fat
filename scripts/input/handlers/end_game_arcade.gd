extends "res://scripts/input/handlers/gamepad_handler.gd"

var bag

var state

func _init(bag):
    self.bag = bag
    self.type = InputEvent.JOYSTICK_BUTTON
    self.multi_button = true
    self.state = 0

func handle(event):
    if event.is_pressed() && self.bag.game_state.game_in_progress:

        if self.state == 0 && event.button_index == 19:
            self.state = 1
        elif self.state == 1 && event.button_index == 17:
            self.state = 2
        elif self.state == 2 && event.button_index == 2:
            self.state = 3
        elif self.state == 3 && event.button_index == 6:
            self.state = 4
        else:
            self.state = 0

        if self.state == 4:
            self.bag.action_controller.end_game()



