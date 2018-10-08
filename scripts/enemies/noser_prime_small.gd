extends "res://scripts/enemies/noser_prime.gd"

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/noser_prime_small.xscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')

    self.velocity = 150
    self.attack_strength = 2
    self.max_hp = 30
    self.hp = 30
    self.split_template = 'noser_prime_tiny'
