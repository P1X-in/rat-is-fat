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

    self.velocity = 50
    self.attack_range = 50
    self.attack_strength = 3
    self.attack_cooldown = 3
    self.max_hp = 50
    self.hp = 50
    self.score = 200

    self.stun_duration = 0.4
    self.mass = 3

    self.phase_hp_thresholds = [
        [30, 2],
        [15, 3],
    ]

func phase2():
    self.stun(2)
    self.bag.sample_player.play('game_over')
    self.spawn_enemies(2)

func phase3():
    self.stun(2)
    self.bag.sample_player.play('you_can')
    self.spawn_enemies(4)

func spawn_enemies(amount):
    var type
    var position
    for i in range(0, amount):
        position = self.bag.room_loader.get_spawn_position_on_map(self.ads_positions[i])
        self.bag.enemies.spawn('shia', position)
