extends "res://scripts/items/abstract_item.gd"

func _init(bag).(bag):
    self.avatar = preload("res://scenes/items/cheese.xscn").instance()
    self.initial_position = Vector2(450, 450)

func die():
    self.despawn()

