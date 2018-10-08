extends "res://scripts/enemies/abstract_boss.gd"

var split = true
var split_template = 'noser_prime_medium'
var splits_amount = 2

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/noser_prime.xscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')

    self.velocity = 50
    self.attack_range = 50
    self.attack_strength = 4
    self.attack_cooldown = 3
    self.max_hp = 80
    self.hp = 80
    self.score = 200

    self.stun_duration = 0.4
    self.mass = 3

    self.phase_hp_thresholds = [
        [1, 2],
    ]

func spawn(position):
    .spawn(position)
    self.randomize_movement()

func phase2():
    return

func die():
    self.spawn_splits()
    .die()

func spawn_splits():
    if not self.split:
        return

    var position = self.avatar.get_global_pos()
    var new_guy

    for i in range(0, self.splits_amount):
        position.x += pow(-1, i) * (i + 1) * 10
        new_guy = self.bag.enemies.spawn_global(self.split_template, position)
        new_guy.stun(1)
        new_guy.make_invulnerable(1)

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

    print(direction)

    self.bag.timers.set_timeout(5, self, 'randomize_movement')

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
    return
