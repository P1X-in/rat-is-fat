extends "res://scripts/enemies/abstract_boss.gd"

var THRASH_AMOUNT = 2
var THRASH_SPAWN_TIME = 5
var thrash_template = 'fat_rat'


var shield_points = [
    Vector2(17, 2),
    Vector2(17, 8),
    Vector2(5, 8),
]
var shield_points_global = []

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/grumpy_prime.xscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')

    self.velocity = 25
    self.attack_range = 50
    self.attack_strength = 4
    self.attack_cooldown = 2
    self.max_hp = 100
    self.hp = 100
    self.score = 200
    self.is_invulnerable = true

    self.stun_duration = 0.4
    self.mass = 3

    self.phase_hp_thresholds = [
        [1, 2],
    ]

    for point in self.shield_points:
        self.shield_points_global.push_back(self.bag.room_loader.translate_position(point))

func spawn(position):
    .spawn(position)
    self.randomize_movement()
    self.schedule_thrash_spawn()

func phase2():
    return

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

func randomize_movement():
    if self.hp < 1:
        return

    var direction

    var x = randi() % 15 + 1
    var y = randi() % 9 + 1

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
