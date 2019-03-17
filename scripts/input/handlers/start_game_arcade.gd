extends "res://scripts/input/handlers/gamepad_handler.gd"

var bag

func _init(bag, button):
    self.bag = bag
    self.type = InputEvent.JOYSTICK_BUTTON
    self.button_index = button

func handle(event):
    if event.is_pressed() && not self.bag.game_state.game_in_progress && not self.bag.game_state.tag_query_in_progress:
        self.bag.action_controller.start_game()