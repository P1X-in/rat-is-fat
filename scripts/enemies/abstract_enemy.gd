extends "res://scripts/moving_object.gd"

var destination = [0, 0]
var target = null
var aggro_range = 500
var attack_range = 25
var attack_strength = 1
var attack_cooldown = 1
var is_attack_on_cooldown = false
var id = 0
var moving_speed = 1

var drop_chance = 0.3
var power_up_chance = 0.1

func _init(bag).(bag):
    self.velocity = 100
    self.stun_duration = 0.75

func go_to(x, y):
    self.destination[0] = x
    self.destination[1] = y

func process_ai():
    var distance
    var direction = Vector2(0, 0)

    if self.target == null:
        for player in self.bag.players.players:
            if player.is_playing && player.is_alive:
                distance = self.calculate_distance_to_object(player)
                if distance < self.aggro_range:
                    if self.target != null:
                        if self.calculate_distance_to_object(self.target) > distance:
                            self.target = player
                    else:
                        self.target = player
        if self.target == null:
            distance = self.calculate_distance(self.initial_position)
            if distance > 10:
                direction = self.cast_movement_vector(self.initial_position)
                direction = self.randomize_movement_vector(direction)
    else:
        distance = self.calculate_distance_to_object(self.target)
        if not self.target.is_alive || distance > self.aggro_range:
            self.target = null
        elif distance > self.attack_range:
            direction = self.cast_movement_vector(self.target.get_pos())
        elif not self.is_attack_on_cooldown:
            self.attack()

    self.movement_vector[0] = direction.x
    self.movement_vector[1] = direction.y

func cast_movement_vector(destination_point):
    var my_position = self.get_pos()
    var distance = self.calculate_distance(destination_point)
    var scale = 1.0 / distance
    var delta_x = (destination_point.x - my_position.x) * scale
    var delta_y = (destination_point.y - my_position.y) * scale

    return Vector2(delta_x, delta_y)

func randomize_movement_vector(vector):
    var range_x = vector.x / 10
    var range_y = vector.y / 10

    randomize()
    # randi() % 10

    return Vector2(vector.x + rand_range(0, range_x), vector.y + rand_range(0, range_y))

func process(delta):
    self.reset_movement()
    self.process_ai()
    .process(delta)
    self.check_out_of_bound()

func check_out_of_bound():
    var lower_bounds = Vector2(-5, 21)
    var upper_bounds = Vector2(645, 360)
    var position = self.avatar.get_global_pos()

    if position.x < lower_bounds.x or position.y < lower_bounds.y or position.x > upper_bounds.x or position.y > upper_bounds.y:
        self.die()

func apply_axis_threshold(axis_value):
    return axis_value

func attack():
    self.play_sound('attack')
    self.is_attack_on_cooldown = true
    self.target.push_back(self)
    self.target.recieve_damage(self.attack_strength)
    self.bag.timers.set_timeout(self.attack_cooldown, self, "attack_cooled_down")

func attack_cooled_down():
    self.is_attack_on_cooldown = false

func die():
    self.bag.enemies.del_enemy(self)
    self.roll_loot()
    .die()


func stun(duration=null):
    .stun(duration)
    self.avatar.set_opacity(1)
    self.animations.play('hit')

func remove_stun():
    .remove_stun()
    self.avatar.set_opacity(1)
    self.animations.play('run')

func roll_loot():
    var global_position = self.get_pos()
    var item
    global_position.y += 10
    if randf() <= self.drop_chance:
        if randf() <= self.power_up_chance:
            item = self.bag.items.spawn_global('medicals', global_position)
        else:
            item = self.bag.items.spawn_global('cheese', global_position)
        self.bag.game_state.current_cell.add_item(item)
