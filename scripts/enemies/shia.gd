extends "res://scripts/enemies/abstract_enemy.gd"

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/shia.xscn").instance()

