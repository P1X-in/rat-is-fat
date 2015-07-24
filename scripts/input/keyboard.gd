

extends "res://scripts/input/abstract_device.gd"

func _init():
    self.handled_input_types = [
        InputEvent.KEY,
    ]