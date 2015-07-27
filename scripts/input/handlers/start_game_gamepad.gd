extends "res://scripts/input/handlers/gamepad_handler.gd"

var bag

func _init(bag):
    self.bag = bag
    self.type = InputEvent.JOYSTICK_BUTTON
    self.button_index = Globals.get("platform_input/xbox_start")

func handle(event):
    if event.is_pressed() && not self.bag.game_state.game_in_progress:
        self.bag.action_controller.start_game()