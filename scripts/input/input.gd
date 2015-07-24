
var devices = {
    "keyboard" : preload("res://scripts/input/keyboard.gd").new(),
    "mouse" : preload("res://scripts/input/mouse.gd").new(),
    "pad0" : preload("res://scripts/input/gamepad.gd").new(0),
    "pad1" : preload("res://scripts/input/gamepad.gd").new(1),
    "pad2" : preload("res://scripts/input/gamepad.gd").new(2),
    "pad3" : preload("res://scripts/input/gamepad.gd").new(3),
}

var handle_event(event):
    return