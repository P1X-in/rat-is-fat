extends "res://scripts/enemies/abstract_boss.gd"


const THRASH_AMOUNT = 2
var THRASH_SPAWN_TIME = 5
var VULNERABLE_TIME = 3.5
var RAINBOW_DELAY = 5
var thrash_template = 'fat_rat'


var shield_points = [
    Vector2(17, 3),
    Vector2(17, 8),
    Vector2(2, 8),
]
var shield_points_global = []

var shield
var angry_body = null
var rainbow_spawned = true
var rainbow = 'rainbow'

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/grumpy_prime.xscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')
    self.angry_body = self.avatar.get_node('angry')
    self.shield = self.avatar.get_node('shield')
    self.hit_particles = self.avatar.get_node('hitparticles')

    self.velocity = 25
    self.attack_range = 50
    self.attack_strength = 4
    self.attack_cooldown = 2
    self.max_hp = 200
    self.hp = 200
    self.score = 200
    self.is_invulnerable = true

    self.stun_duration = 0.4
    self.mass = 3

    self.phase_hp_thresholds = [
        [100, 2],
    ]

    for point in self.shield_points:
        self.shield_points_global.push_back(self.bag.room_loader.translate_position(point))

func spawn(position):
    .spawn(position)
    self.randomize_movement()
    self.raise_shield()
    self.spawn_thrash()

func phase2():
    self.body_part_body.hide()
    self.angry_body.show()
    self.THRASH_SPAWN_TIME = 2.5
    self.VULNERABLE_TIME = 2
    self.RAINBOW_DELAY = 2.5
    self.velocity = 50

func process_ai():
    var distance

    if self.target == null:
        for player in self.bag.players.players:
            if player.is_playing && player.is_alive:
                distance = self.calculate_distance_to_object(player)
                if distance < self.aggro_range:
                    self.target = player
                    break

    if self.target != null:
        distance = self.calculate_distance_to_object(self.target)
        if not self.target.is_alive || distance > self.aggro_range:
            self.target = null
        elif distance < self.attack_range and not self.is_attack_on_cooldown:
            self.attack()

    if not self.rainbow_spawned:
        self.rainbow_spawned = true
        self.bag.timers.set_timeout(self.RAINBOW_DELAY, self, 'spawn_rainbow')

func randomize_movement():
    if self.hp < 1:
        return

    var direction

    var x = randi() % 18 + 1
    var y = randi() % 8 + 1

    direction = self.bag.room_loader.translate_position(Vector2(x, y))
    direction = self.cast_movement_vector(direction)

    self.movement_vector[0] = direction.x
    self.movement_vector[1] = direction.y

func reset_movement():
    return

func modify_position(delta):
    var x = self.movement_vector[0]
    var y = self.movement_vector[1]
    var motion = Vector2(x, y) * self.velocity * delta
    self.avatar.move(motion)
    self.flip(self.movement_vector[0])
    if (self.avatar.is_colliding()):
        var n = self.avatar.get_collision_normal()
        motion = n.slide(motion)
        self.avatar.move(motion)
        self.randomize_movement()

func external_stun(duration=null):
    if self.is_invulnerable:
        return

    .external_stun(duration)

func push_back(enemy):
    if self.is_invulnerable:
        return

    .push_back(enemy)

func schedule_thrash_spawn():
    self.bag.timers.set_timeout(self.THRASH_SPAWN_TIME, self, 'spawn_thrash')

func spawn_thrash():
    if self.hp < 1:
        return

    var position = self.avatar.get_global_pos()
    var new_guy

    for i in range(0, self.THRASH_AMOUNT):
        position = self.avatar.get_global_pos()
        position.x += pow(-1, i) * 30
        position.y += 30
        new_guy = self.bag.enemies.spawn_global(self.thrash_template, position)
        new_guy.is_attack_on_cooldown = true
        self.bag.timers.set_timeout(self.attack_cooldown, new_guy, "attack_cooled_down")
        new_guy.make_invulnerable(1)

    self.schedule_thrash_spawn()

func disable_shield():
    self.is_invulnerable = false
    self.shield.hide()
    self.bag.timers.set_timeout(self.VULNERABLE_TIME, self, 'raise_shield')

func raise_shield():
    self.animations.play('shield_on')
    self.bag.timers.set_timeout(0.5, self, 'raise_shield_anim_end')

func raise_shield_anim_end():
    self.is_invulnerable = true
    self.rainbow_spawned = false
    self.shield.show()

func spawn_rainbow():
    if self.hp < 1:
        return

    self.bag.enemies.spawn_global(self.rainbow, self.pick_next_point())

func pick_next_point():
    return self.shield_points_global[randi() % self.shield_points_global.size()]


func flip_body_parts(flip_flag):
    .flip_body_parts(flip_flag)
    self.angry_body.set_flip_h(flip_flag)
