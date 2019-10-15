extends "res://scripts/enemies/abstract_boss.gd"

var ads_positions = [
    'north3',
    'south3',
    'east3',
    'west3',
]

func _init(bag).(bag):
    self.avatar = preload("res://scenes/enemies/shia_prime.xscn").instance()
    self.body_part_head = self.avatar.get_node('body')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('body')
    self.animations = self.avatar.get_node('body_animations')
    self.hit_particles = self.avatar.get_node('hitparticles')
    self.speech_bubble = self.avatar.get_node('speech')

    self.velocity = 50
    self.attack_range = 50
    self.attack_strength = 3
    self.attack_cooldown = 3
    self.max_hp = 50
    self.hp = 60
    self.score = 200

    self.stun_duration = 0.4
    self.mass = 3

    self.phase_hp_thresholds = [
        [40, 2],
        [20, 3],
    ]

func attach():
    .attach()
    self.bag.timers.set_timeout(0.3, self, "phase1")

func phase1():
    self.speak("Just do it!", 2, true)

func phase2():
    self.speak("Stop giving up!", 2, true)
    self.bag.sample_player.play('game_over')
    self.spawn_enemies(2)

func phase3():
    self.speak("You can do it!", 2, true)
    self.bag.sample_player.play('you_can')
    self.spawn_enemies(4)

func spawn_enemies(amount):
    var type
    var position
    for i in range(0, amount):
        position = self.bag.room_loader.get_spawn_position_on_map(self.ads_positions[i])
        self.bag.enemies.spawn('shia', position)
