extends "res://scripts/enemies/abstract_enemy.gd"


func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/lizard.tscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')
    self.hit_particles = self.avatar.get_node('hitparticles')

    self.aggro_range = 250
    self.attack_range = 40
    self.velocity = 70
    self.score = 20
