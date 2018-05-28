extends "res://scripts/moving_object.gd"

var player_id
var is_playing = false
var is_alive = true
var attack_range = 100
var attack_width = PI * 0.33
var attack_strength = 1
var attack_cooldown = 0.4
var is_attack_on_cooldown = false
var is_attacking = false
var is_invulnerable = false
var invulnerability_period = 0.5
var blast

var target_cone
var target_cone_vector = [0, 0]
var target_cone_angle = 0.0

var panel
var hp_cap = 16

var EXIT_THRESHOLD = 35

func _init(bag, player_id).(bag):
    self.bag = bag
    self.player_id = player_id
    self.velocity = 200
    self.hp = 10
    self.max_hp = 10
    self.score = 0
    self.avatar = preload("res://scenes/player/player.xscn").instance()
    self.body_part_head = self.avatar.get_node('head')
    self.hat = self.body_part_head.get_node('hat')
    self.body_part_body = self.avatar.get_node('body')
    self.body_part_footer = self.avatar.get_node('footer')
    self.target_cone = self.avatar.get_node('attack_cone')
    self.animations = self.avatar.get_node('body_animations')
    self.blast = self.avatar.get_node('blast_animations')

    if not self.bag.input.arcade:
        self.bind_gamepad(player_id)
    else:
        self.bind_arcade(player_id)
    self.panel = self.bag.hud.bind_player_panel(player_id)
    self.hat.set_frame(player_id)
    self.update_bars()

    self.sounds['hit'] = 'player_hit'
    self.sounds['die'] = 'player_die'
    self.sounds['attack1'] = 'player_attack1'
    self.sounds['attack2'] = 'player_attack2'

func bind_arcade(player):
    var arcade = self.bag.input.devices['arcade']
    if player == 0:
        arcade.register_handler(preload("res://scripts/input/handlers/player_enter_game_arcade.gd").new(self.bag, self, 14))
        arcade.register_handler(preload("res://scripts/input/handlers/player_enter_game_arcade.gd").new(self.bag, self, 0))
        arcade.register_handler(preload("res://scripts/input/handlers/player_move_arcade.gd").new(self.bag, self, 1, 13, -1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_move_arcade.gd").new(self.bag, self, 1, 12, 1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_move_arcade.gd").new(self.bag, self, 0, 11, -1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_move_arcade.gd").new(self.bag, self, 0, 10, 1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_cone_arcade.gd").new(self.bag, self, 1, 13, -1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_cone_arcade.gd").new(self.bag, self, 1, 12, 1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_cone_arcade.gd").new(self.bag, self, 0, 11, -1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_cone_arcade.gd").new(self.bag, self, 0, 10, 1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 15))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 16))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 17))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 18))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 19))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 20))
    else:
        arcade.register_handler(preload("res://scripts/input/handlers/player_enter_game_arcade.gd").new(self.bag, self, 0))
        arcade.register_handler(preload("res://scripts/input/handlers/player_move_axis_arcade.gd").new(self.bag, self, 0, 0))
        arcade.register_handler(preload("res://scripts/input/handlers/player_move_axis_arcade.gd").new(self.bag, self, 1, 1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_cone_axis_arcade.gd").new(self.bag, self, 0, 0))
        arcade.register_handler(preload("res://scripts/input/handlers/player_cone_axis_arcade.gd").new(self.bag, self, 1, 1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 1))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 2))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 3))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 4))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 5))
        arcade.register_handler(preload("res://scripts/input/handlers/player_attack_arcade.gd").new(self.bag, self, 6))

func bind_gamepad(id):
    var gamepad = self.bag.input.devices['pad' + str(id)]
    gamepad.register_handler(preload("res://scripts/input/handlers/player_enter_game_gamepad.gd").new(self.bag, self))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_move_axis.gd").new(self.bag, self, 0))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_move_axis.gd").new(self.bag, self, 1))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_cone_gamepad.gd").new(self.bag, self, Globals.get("platform_input/xbox_right_stick_x"), 0))
    gamepad.register_handler(preload("res://scripts/input/handlers/player_cone_gamepad.gd").new(self.bag, self, Globals.get("platform_input/xbox_right_stick_y"), 1))
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
    if not self.bag.players.is_living_player_in_game():
        self.bag.sample_player.play('game_over')
        self.bag.action_controller.end_game()

func remove_from_game():
    self.panel.hide()
    self.is_processing = false
    self.despawn()
    self.reset()


func process(delta):
    self.adjust_attack_cone()
    .process(delta)
    self.check_doors()
    self.handle_items()
    self.process_attack()

func process_attack():
    if self.is_attacking && not self.is_attack_on_cooldown:
        self.attack()

func modify_position(delta):
    if not self.is_attack_on_cooldown:
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

func respawn():
    if self.is_alive || not self.is_playing:
        return
    self.panel.reset()
    self.reset()
    self.enter_game()


func handle_items():
    var items = self.bag.items.get_items_near_object(self)
    for item in items:
        if item.power_up_type == 0:
            self.get_fat(item.power_up_amount)
        else:
            self.get_power(item.power_up_amount)
        self.score = self.score + item.score
        item.pick()
        self.update_bars()


func adjust_attack_cone():
    #if abs(self.target_cone_vector[0]) < self.AXIS_THRESHOLD || abs(self.target_cone_vector[1]) < self.AXIS_THRESHOLD:
    #    return
    if self.target_cone_vector[0] == 0 && self.target_cone_vector[1] == 0:
        self.target_cone.hide()
        return

    self.target_cone.show()

    self.target_cone_angle = -atan2(self.target_cone_vector[1], self.target_cone_vector[0]) - PI/2
    self.target_cone.set_rot(self.target_cone_angle)

func attack():
    if self.is_attack_on_cooldown:
        return

    var enemies
    var random_attack = 'attack'+ str(1 + randi() % 2)

    self.is_attack_on_cooldown = true

    if not self.animations.get_current_animation() == 'attack1' and not self.animations.get_current_animation() == 'attack2' :
        self.animations.play(random_attack)
        self.play_sound(random_attack)
        self.blast.play('blast')
    elif not self.animations.is_playing():
        if self.animations.get_current_animation() == 'attack1':
            self.animations.play('attack2')
            self.play_sound('attack2')
        else:
            self.animations.play('attack1')
            self.play_sound('attack1')
        self.blast.play('blast')

    enemies = self.bag.enemies.get_enemies_near_object(self, self.attack_range, self.target_cone_vector, self.attack_width)
    for enemy in enemies:
        if enemy.will_die(self.attack_strength):
            self.score += enemy.score
            self.update_bars()

        enemy.recieve_damage(self.attack_strength)
        enemy.push_back(self)
    self.bag.timers.set_timeout(self.attack_cooldown, self, "attack_cooled_down")

func get_power(amount):
    self.attack_strength += amount
    if self.attack_strength >= 16:
        self.die();

    self.hp -= amount
    self.max_hp -= amount
    self.update_bars()

func get_fat(amount):
    self.hp += amount
    self.max_hp += amount
    if self.max_hp > self.hp_cap:
        self.max_hp = self.hp_cap
    if self.hp > self.max_hp:
        self.hp = self.max_hp
    self.update_bars()

func check_colisions():
    return

func check_doors():
    if not self.bag.game_state.doors_open:
        return;

    var door_coords
    var new_coords = [0, 0]
    var cell = self.bag.game_state.current_cell
    if cell.north != null:
        door_coords = self.bag.room_loader.door_definitions['north'][1]
        new_coords[0] = door_coords[0] + 7
        new_coords[1] = door_coords[1] + 0
        if self.check_exit(new_coords, cell.north, Vector2(16, -15)):
            self.bag.players.move_to_entry_position('south')
            return
    if cell.south != null:
        door_coords = self.bag.room_loader.door_definitions['south'][1]
        new_coords[0] = door_coords[0] + 7
        new_coords[1] = door_coords[1] + 10
        if self.check_exit(new_coords, cell.south, Vector2(16, 40)):
            self.bag.players.move_to_entry_position('north')
            return
    if cell.east != null:
        door_coords = self.bag.room_loader.door_definitions['east'][1]
        new_coords[0] = door_coords[0] + 16
        new_coords[1] = door_coords[1] + 4
        if self.check_exit(new_coords, cell.east, Vector2(40, 0)):
            self.bag.players.move_to_entry_position('west')
            return
    if cell.west != null:
        door_coords = self.bag.room_loader.door_definitions['west'][1]
        new_coords[0] = door_coords[0] + 0
        new_coords[1] = door_coords[1] + 4
        if self.check_exit(new_coords, cell.west, Vector2(-10, 0)):
            self.bag.players.move_to_entry_position('east')
            return

    self.check_level_exit()

func check_exit(door_coords, cell, door_offset):
    var exit_area = self.bag.room_loader.translate_position(Vector2(door_coords[0] + self.bag.room_loader.side_offset, door_coords[1]))
    exit_area = exit_area + door_offset
    var distance = self.calculate_distance(exit_area)
    if distance < self.EXIT_THRESHOLD:
        self.bag.map.switch_to_cell(cell)
        return true
    return false

func check_level_exit():
    var exit_area
    var distance
    for exit in self.bag.game_state.current_room.exits:
        exit_area = self.bag.room_loader.translate_position(Vector2(exit[0] + self.bag.room_loader.side_offset, exit[1]))
        distance = self.calculate_distance(exit_area)
        if distance < self.EXIT_THRESHOLD:
            self.bag.action_controller.next_level(exit[2])

func move_to_entry_position(name):
    var entry_position_id = self.bag.players.get_first_free_entry_position_num(self.player_id)
    var entry_position
    entry_position = self.bag.room_loader.get_spawn_position(name + str(entry_position_id))
    self.avatar.set_pos(entry_position)

func update_bars():
    self.panel.update_bar(self.panel.fat_bar, self.hp - 1, 0)
    self.panel.update_bar(self.panel.power_bar, self.attack_strength - 1, 3)
    self.panel.update_points(self.score)

func set_hp(hp):
    .set_hp(hp)
    self.update_bars()

func recieve_damage(damage):
    if self.is_invulnerable:
        return
    self.is_invulnerable = true
    self.bag.camera.shake()
    .recieve_damage(damage)
    self.bag.timers.set_timeout(self.invulnerability_period, self, "loose_invulnerability")

func loose_invulnerability():
    self.is_invulnerable = false

func reset():
    self.attack_strength = 1
    self.hp = 10
    self.max_hp = 10
    self.target_cone_vector = [0, 0]
    self.target_cone_angle = 0.0
    self.is_playing = false
    self.is_alive = true
    self.movement_vector = [0, 0]
    self.score = 0
    self.is_attack_on_cooldown = false
    self.is_attacking = false
    self.update_bars()

func attack_cooled_down():
    self.is_attack_on_cooldown = false
