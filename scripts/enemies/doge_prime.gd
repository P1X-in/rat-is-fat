extends "res://scripts/enemies/abstract_boss.gd"

const IRRITATED_TIMER = 2

const IDLE_CHATTER_DELAY = 3
const IDLE_CHATTER_TIME = 1

var irritated = false
var calm = true
var rampage_hp_threshold = 10

var body_angry
var body_moving

var path_points = [
    Vector2(17, 3),
    Vector2(17, 8),
    Vector2(2, 8),
    Vector2(2, 3),
]
var path_points_global = []
var target_point = null
var current_point = 0

var target_icon

var idle_chatter = [
    "wow",
    "such bored",
    "much guarding"
]
var is_idle_chatting = true
var angry_chatter = [
    "such rude",
    "much angry"
]

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/doge_prime.xscn").instance()
    self.target_icon = preload("res://scenes/enemies/doge_prime_target.tscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')
    self.hit_particles = self.avatar.get_node('hitparticles')

    self.body_angry = self.avatar.get_node('body2')
    self.body_moving = self.avatar.get_node('body3')
    self.speech_bubble = self.avatar.get_node('speech')

    self.velocity = 250
    self.attack_range = 50
    self.aggro_range = 75
    self.attack_strength = 2
    self.attack_cooldown = 3
    self.max_hp = 25
    self.hp = 25
    self.rampage_hp_threshold = 10
    self.score = 200

    self.stun_duration = 0.4
    self.mass = 30
    self.is_pushable = false
    self.is_stunable = false

    self.calm = true
    self.irritated = false

    self.phase_hp_thresholds = [
        [25, 2],
    ]

    for point in self.path_points:
        self.path_points_global.push_back(self.bag.room_loader.translate_position(point))

func process_ai():
    var distance
    var direction = Vector2(0, 0)

    self.target = null
    if not self.calm:
        for player in self.bag.players.players:
            if player.is_playing && player.is_alive:
                distance = self.calculate_distance_to_object(player)
                if distance < self.aggro_range:
                    if self.target != null:
                        if self.calculate_distance_to_object(self.target) > distance:
                            self.target = player
                    else:
                        self.target = player
                    break

    if self.calm and not self.irritated:
        for player in self.bag.players.players:
            if player.is_playing && player.is_alive:
                distance = self.calculate_distance_to_object(player)
                if distance < self.aggro_range:
                    self.irritate()
                    break

    if self.target != null:
        distance = self.calculate_distance_to_object(self.target)
        if not self.target.is_alive || distance > self.aggro_range:
            self.target = null
        elif distance < self.attack_range and not self.is_attack_on_cooldown:
            self.attack()

    if self.target_point != null and not self.calm:
        distance = self.calculate_distance(self.target_point)
        if distance < 5:
            self.target_point = null
            self.calm_down()
        else:
            direction = self.cast_movement_vector(self.target_point)

    self.movement_vector[0] = direction.x
    self.movement_vector[1] = direction.y

func enrage():
    self.is_invulnerable = true
    self.calm = false
    self.body_angry.hide()
    self.body_moving.show()
    self.body_part_body.hide()

func calm_down():
    self.is_invulnerable = false
    self.calm = true
    self.irritated = false
    self.body_angry.hide()
    self.body_moving.hide()
    self.body_part_body.show()
    self.target_icon.hide()

    var timer = randi() % 3
    timer += 2

    if self.hp > self.rampage_hp_threshold:
        self.bag.timers.set_timeout(timer, self, 'irritate')
    else:
        self.irritate()

func irritate():
    if self.irritated:
        return

    self.irritated = true
    self.is_idle_chatting = false
    self.pick_next_point()
    self.body_part_body.hide()
    self.body_angry.show()
    self.body_moving.hide()
    self.bag.timers.set_timeout(self.IRRITATED_TIMER, self, 'enrage')
    self.angry_chatter()

func phase2():
    return

func pick_next_point():
    var next_point = self.current_point

    while (next_point == self.current_point):
        next_point = randi() % self.path_points_global.size()

    self.current_point = next_point
    self.target_point = self.path_points_global[next_point]

    self.target_icon.show()
    self.target_icon.set_pos(self.target_point)


func push_back(enemy):
    .push_back(enemy)
    if not self.irritated:
        self.irritate()

func flip_body_parts(flip_flag):
    .flip_body_parts(flip_flag)
    self.body_angry.set_flip_h(flip_flag)
    self.body_moving.set_flip_h(flip_flag)

func attach():
    .attach()
    self.bag.action_controller.attach_object(self.target_icon)
    self.target_icon.hide()
    self.bag.timers.set_timeout(1, self, "idle_chatter")

func detach():
    .detach()
    self.bag.action_controller.detach_object(self.target_icon)


func idle_chatter():
    if not self.is_idle_chatting:
        return

    var random_text = self.idle_chatter[randi() % self.idle_chatter.size()]
    self.speak(random_text, self.IDLE_CHATTER_TIME)
    self.bag.timers.set_timeout(self.IDLE_CHATTER_DELAY, self, "idle_chatter")

func angry_chatter():
    var random_text = self.angry_chatter[randi() % self.angry_chatter.size()]
    self.speak(random_text, self.IDLE_CHATTER_TIME)
