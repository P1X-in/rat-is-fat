extends "res://scripts/input/handlers/keyboard_handler.gd"

var bag

func _init(bag, key):
    self.bag = bag
    self.scancode = key

func handle(event):
    if event.is_echo():
        return
    if event.is_pressed() && self.bag.game_state.game_in_progress:
        if self.bag.game_state.level < 3:
            self.bag.action_controller.next_level('next')
        else:
            self.bag.action_controller.next_level('end')

