extends "res://scripts/input/handlers/keyboard_handler.gd"

var bag

func _init(bag, key):
    self.bag = bag
    self.scancode = key

func handle(event):
    if event.is_echo():
        return
    if event.is_pressed() && self.bag.game_state.game_in_progress:
        self.bag.players.empower(1)
