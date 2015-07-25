extends "res://scripts/object.gd"

var id = 0
var power_up_amount = 1

func _init(bag).(bag):
    self.initial_position = Vector2(0, 0)

func die():
    self.despawn()

