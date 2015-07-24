extends "res://scripts/input/handlers/keyboard_handler.gd"

var bag
var player

func _init(bag, player):
    self.bag = bag
    self.player = player
    self.scancode = KEY_C

func handle(event):
    if event.is_pressed() && self.player.is_playing && self.player.is_alive:
        self.player.attack()