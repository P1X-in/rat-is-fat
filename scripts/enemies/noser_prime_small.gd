extends "res://scripts/enemies/noser_prime.gd"

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/noser_prime_small.xscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')
    self.hit_particles = self.avatar.get_node('hitparticles')
    self.speech_bubble = self.avatar.get_node('speech')

    self.velocity = 150
    self.attack_range = 30
    self.attack_strength = 1
    self.max_hp = 10
    self.hp = 14
    self.drop_chance = 0
    self.split_template = 'noser_prime_tiny'
    self.taunt = "Pal"
    self.has_tombstone = false
