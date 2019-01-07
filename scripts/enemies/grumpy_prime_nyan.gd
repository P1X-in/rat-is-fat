extends "res://scripts/enemies/abstract_boss.gd"

var target_template = 'grumpy_prime'

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/nyan.tscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')

    self.velocity = 150
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


func process_ai():
    var distance
    var direction = Vector2(0, 0)

    var grumpy_prime = self.bag.enemies.get_enemy(self.target_template)

    if grumpy_prime == null:
        self.die()
        return

    distance = self.calculate_distance_to_object(grumpy_prime)
    if distance < self.aggro_range:
        grumpy_prime.disable_shield()
        self.die()
        return
    else:
        direction = self.cast_movement_vector(grumpy_prime.get_pos())

    self.movement_vector[0] = direction.x
    self.movement_vector[1] = direction.y

func external_stun(duration=null):
    return

func push_back(enemy):
    return
