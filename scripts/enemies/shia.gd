extends "res://scripts/enemies/abstract_enemy.gd"

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/shia.xscn").instance()
    self.initial_position = Vector2(50, 50)
