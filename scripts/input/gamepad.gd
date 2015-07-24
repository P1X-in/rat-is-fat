
extends "res://scripts/input/abstract_device.gd"

func _init(device_id):
    self.handled_input_types = [
        InputEvent.JOYSTICK_MOTION,
        InputEvent.JOYSTICK_BUTTON,
    ]
    self.device_id = device_id