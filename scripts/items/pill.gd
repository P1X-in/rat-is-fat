extends "res://scripts/items/abstract_item.gd"

var id = 0
var power_up_amount = 1

func _init(bag).(bag):
    self.avatar = preload("res://scenes/items/pill.xscn").instance()
    self.initial_position = Vector2(400, 400)

func die():
    self.despawn()

