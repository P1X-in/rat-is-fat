extends "res://scripts/enemies/abstract_enemy.gd"


func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/fat_rat.xscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')

    self.aggro_range = 250
    self.attack_range = 40
    self.velocity = 70
