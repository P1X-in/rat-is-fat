extends "res://scripts/enemies/abstract_enemy.gd"

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/shia.xscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')
    self.hit_particles = self.avatar.get_node('hitparticles')
    self.score = 120
    self.drop_chance = 0