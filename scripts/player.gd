extends "res://scripts/moving_object.gd"

var player_id
var is_playing = false
var is_alive = true
var attack_range = 100
var attack_width = PI * 0.33
var attack_strength = 1
var blast

var target_cone
var target_cone_vector = [0, 0]
var target_cone_angle = 0.0

var panel

var EXIT_THRESHOLD = 30

func _init(bag, player_id).(bag):
    self.bag = bag
    self.player_id = player_id
    self.velocity = 200
    self.avatar = preload("res://scenes/player/player.xscn").instance()
    self.body_part_head = self.avatar.get_node('head')
    self.hat = self.body_part_head.get_node('hat')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('footer')
    self.target_cone = self.avatar.get_node('attack_cone')
    self.animations = self.avatar.get_node('body_animations')
    self.blast = self.avatar.get_node('blast_animations')

    self.bind_gamepad(player_id)
    self.panel = self.bag.hud.bind_player_panel(player_id)
    self.hat.set_frame(player_id)

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
    self.spawn(self.bag.room_loader.get_spawn_position('initial' + str(self.player_id)))
    self.panel.show()

func spawn(position):
    self.is_alive = true
    .spawn(position)

func die():
    self.is_alive = false
    self.panel.hide()
    .die()

func process(delta):
    self.adjust_attack_cone()
    .process(delta)
    self.check_doors()
    self.handle_items()

func modify_position(delta):
    .modify_position(delta)
    self.flip(self.target_cone_vector[0])
    self.handle_animations()

func handle_animations():
    if not self.animations.is_playing():
        if abs(self.movement_vector[0]) > self.AXIS_THRESHOLD || abs(self.movement_vector[1]) > self.AXIS_THRESHOLD:
            self.animations.play('run')
        else:
            self.animations.play('idle')
    else:
        if self.animations.get_current_animation() == 'idle' && (abs(self.movement_vector[0]) > self.AXIS_THRESHOLD || abs(self.movement_vector[1]) > self.AXIS_THRESHOLD):
            self.animations.play('run')
        elif self.animations.get_current_animation() == 'run' && abs(self.movement_vector[0]) < self.AXIS_THRESHOLD && abs(self.movement_vector[1]) < self.AXIS_THRESHOLD:
            self.animations.play('idle')


func handle_items():
    var items = self.bag.items.get_items_near_object(self)
    for item in items:
        if item.power_up_type == 0:
            self.get_fat(item.power_up_amount)
        else:
            self.get_powert(item.power_up_amount)

        item.pick()


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
        self.blast.play('blast')
    elif not self.animations.is_playing():
        if self.animations.get_current_animation() == 'attack1':
            self.animations.play('attack2')
        else:
            self.animations.play('attack1')
        self.blast.play('blast')

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

func check_colisions():
    return

func check_doors():
    if not self.bag.game_state.doors_open:
        return;

    var door_coords
    var cell = self.bag.game_state.current_cell
    if cell.north != null:
        door_coords = self.bag.room_loader.door_definitions['north'][1]
        if self.check_exit(door_coords, cell.north, Vector2(16, 0)):
            self.bag.players.move_to_entry_position('south')
            return
    if cell.south != null:
        door_coords = self.bag.room_loader.door_definitions['south'][1]
        if self.check_exit(door_coords, cell.south, Vector2(16, 40)):
            self.bag.players.move_to_entry_position('north')
            return
    if cell.east != null:
        door_coords = self.bag.room_loader.door_definitions['east'][1]
        if self.check_exit(door_coords, cell.east, Vector2(40, 0)):
            self.bag.players.move_to_entry_position('west')
            return
    if cell.west != null:
        door_coords = self.bag.room_loader.door_definitions['west'][1]
        if self.check_exit(door_coords, cell.west, Vector2(-10, 0)):
            self.bag.players.move_to_entry_position('east')
            return

func check_exit(door_coords, cell, door_offset):
    var exit_area = self.bag.room_loader.translate_position(Vector2(door_coords[0] + self.bag.room_loader.side_offset, door_coords[1]))
    exit_area = exit_area + door_offset
    var distance = self.calculate_distance(exit_area)
    if distance < self.EXIT_THRESHOLD:
        self.bag.map.switch_to_cell(cell)
        return true
    return false

func move_to_entry_position(name):
    var entry_position
    print(name, self.player_id)
    entry_position = self.bag.room_loader.get_spawn_position(name + str(self.player_id))
    self.avatar.set_pos(entry_position)

