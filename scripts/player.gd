extends "res://scripts/moving_object.gd"

var is_playing = false
var is_alive = true
var attack_range = 100
var attack_width = PI * 0.33
var attack_strength = 1

var target_cone
var target_cone_vector = [0, 0]
var target_cone_angle = 0.0

var panel

func _init(bag, player_id).(bag):
    self.bag = bag
    self.velocity = 200
    self.avatar = preload("res://scenes/player/player.xscn").instance()
    self.body_part_head = self.avatar.get_node('head')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('footer')
    self.target_cone = self.avatar.get_node('attack_cone')
    self.animations = self.avatar.get_node('body_animations')

    self.bind_gamepad(player_id)
    self.panel = self.bag.hud.bind_player_panel(player_id)

func bind_gamepad(id):
    var gamepad = self.bag.input.devices['pad' + str(id)]
    gamepad.register_handler(preload("res://scripts/input/handlers/player_enter_game_gamepad.gd").new(self.bag, self))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_move_axis.gd").new(self.bag, self, 0))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_move_axis.gd").new(self.bag, self, 1))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_cone_gamepad.gd").new(self.bag, self, 2))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_cone_gamepad.gd").new(self.bag, self, 3))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_attack_gamepad.gd").new(self.bag, self))

func bind_keyboard_and_mouse():
    var keyboard = self.bag.input.devices['keyboard']
    var mouse = self.bag.input.devices['mouse']
    keyboard.register_handler(preload("res://scripts/input/handlers/player_enter_game_keyboard.gd").new(self.bag, self))
    keyboard.register_handler(preload("res://scripts/input/handlers/player_move_key.gd").new(self.bag, self, 1, KEY_W, -1))
    keyboard.register_handler(preload("res://scripts/input/handlers/player_move_key.gd").new(self.bag, self, 1, KEY_S, 1))
    keyboard.register_handler(preload("res://scripts/input/handlers/player_move_key.gd").new(self.bag, self, 0, KEY_A, -1))
    keyboard.register_handler(preload("res://scripts/input/handlers/player_move_key.gd").new(self.bag, self, 0, KEY_D, 1))
    mouse.register_handler(preload("res://scripts/input/handlers/player_cone_mouse.gd").new(self.bag, self))
    mouse.register_handler(preload("res://scripts/input/handlers/player_attack_mouse.gd").new(self.bag, self))

func enter_game():
    self.is_playing = true
    self.spawn(self.bag.room_loader.get_spawn_position('initial'))
    self.panel.show()

func spawn(position):
    self.is_alive = true
    .spawn(position)

func die():
    self.is_alive = false
    .die()

func process(delta):
    self.adjust_attack_cone()
    .process(delta)

func modify_position(delta):
    .modify_position(delta)
    self.flip(self.target_cone_vector[0])
    if not self.animations.is_playing():
        self.animations.play('run')

func adjust_attack_cone():
    if abs(self.target_cone_vector[0]) < self.AXIS_THRESHOLD || abs(self.target_cone_vector[1]) < self.AXIS_THRESHOLD:
        return

    self.target_cone_angle = -atan2(self.target_cone_vector[1], self.target_cone_vector[0]) - PI/2
    self.target_cone.set_rot(self.target_cone_angle)

func attack():
    var enemies
    var random_attack = 'attack'+ str(1 + randi() % 2)

    if not self.animations.get_current_animation() == 'attack1' and not self.animations.get_current_animation() == 'attack2' :
        self.animations.play(random_attack);
    elif not self.animations.is_playing():
        if self.animations.get_current_animation() == 'attack1':
            self.animations.play('attack2')
        else:
            self.animations.play('attack1')

    enemies = self.bag.enemies.get_enemies_near_object(self, self.attack_range, self.target_cone_vector, self.attack_width)
    for enemy in enemies:
        enemy.recieve_damage(self.attack_strength)
        enemy.push_back(self)

func get_power(amount):
    self.attack_strength += amount
    if self.attack_range >= 16:
        self.die();

    self.hp -= amount
    self.max_hp -= amount

func get_fat(amount):
    self.hp += amount
    self.max_hp += amount


