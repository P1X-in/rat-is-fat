extends "res://scripts/items/abstract_item.gd"

func _init(bag).(bag):
    self.avatar = preload("res://scenes/items/cheese.xscn").instance()

func die():
    self.despawn()

