extends "res://scripts/enemies/abstract_boss.gd"

const IRRITATED_TIMER = 0.7
const IRRITATED_THRESHOLD = 2

var irritated = false
var irritated_counter = 0

var boss_template = 'grumpy_prime'

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/grumpy_prime_pile.tscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')

    self.velocity = 0
    self.attack_range = 0
    self.aggro_range = 75
    self.attack_strength = 0
    self.attack_cooldown = 10
    self.max_hp = 10
    self.hp = 10
    self.score = 200
    self.is_invulnerable = true
    self.hit_protection = true
    self.has_tombstone = false

    self.irritated = false

    self.movement_vector[0] = 0
    self.movement_vector[1] = 0

func process_ai():
    var distance
    var direction = Vector2(0, 0)

    if not self.irritated:
        for player in self.bag.players.players:
            if player.is_playing && player.is_alive:
                distance = self.calculate_distance_to_object(player)
                if distance < self.aggro_range:
                    self.irritated = true
                    self.shake()
                    break

func shake():
    if self.irritated_counter == self.IRRITATED_THRESHOLD:
        var grumpy_prime = self.bag.enemies.spawn_global(self.boss_template, self.avatar.get_global_pos())
        grumpy_prime.is_attack_on_cooldown = true
        self.bag.timers.set_timeout(self.attack_cooldown, grumpy_prime, "attack_cooled_down")
        grumpy_prime.external_stun(1)

        self.die()
        return

    self.animations.play('shake')
    self.irritated_counter += 1
    self.bag.timers.set_timeout(self.IRRITATED_TIMER, self, 'shake')


func external_stun(duration=null):
    return

func push_back(enemy):
    return
