extends "res://scripts/enemies/abstract_boss.gd"

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/shia.xscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')

    self.velocity = 50
    self.attack_range = 50
    self.attack_strength = 3
    self.attack_cooldown = 3
    self.max_hp = 25
    self.hp = 25