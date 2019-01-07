extends "res://scripts/enemies/abstract_boss.gd"


var spawn_template = 'nyan'

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/rainbow.tscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')

    self.velocity = 0
    self.attack_range = 0
    self.aggro_range = 30
    self.attack_strength = 0
    self.attack_cooldown = 10
    self.max_hp = 10
    self.hp = 10
    self.score = 200
    self.is_invulnerable = true
    self.hit_protection = true
    self.has_tombstone = false
    self.drop_chance = 0

    self.movement_vector[0] = 0
    self.movement_vector[1] = 0

func process_ai():
    var distance
    var direction = Vector2(0, 0)

    for player in self.bag.players.players:
        if player.is_playing && player.is_alive:
            distance = self.calculate_distance_to_object(player)
            if distance < self.aggro_range:
                self.spawn_nyan()
                self.die()
                break

func spawn_nyan():
    self.bag.enemies.spawn_global(self.spawn_template, self.avatar.get_global_pos())

func external_stun(duration=null):
    return

func push_back(enemy):
    return
