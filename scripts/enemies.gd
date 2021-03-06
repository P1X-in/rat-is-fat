
var bag

var enemy_templates = {
    #easy
    'shia' : preload("res://scripts/enemies/shia.gd"),
    'retarded_rat' : preload("res://scripts/enemies/retarded_rat.gd"),
    'fat_rat' : preload("res://scripts/enemies/fat_rat.gd"),
    'jumping_rat' : preload("res://scripts/enemies/jumping_rat.gd"),
    'spider' : preload("res://scripts/enemies/spider.gd"),
    'lizard' : preload("res://scripts/enemies/lizard.gd"),
    'snake' : preload("res://scripts/enemies/snake.gd"),
    'frog' : preload("res://scripts/enemies/frog.gd"),
    'cockroach' : preload("res://scripts/enemies/cockroach.gd"),
    'dog' : preload("res://scripts/enemies/dog.gd"),
    'wasp' : preload("res://scripts/enemies/wasp.gd"),
    'ant' : preload("res://scripts/enemies/ant.gd"),

    #boss
    'shia_prime' : preload("res://scripts/enemies/shia_prime.gd"),
    'doge_prime' : preload("res://scripts/enemies/doge_prime.gd"),
    'noser_prime' : preload("res://scripts/enemies/noser_prime.gd"),
    'noser_prime_medium' : preload("res://scripts/enemies/noser_prime_medium.gd"),
    'noser_prime_small' : preload("res://scripts/enemies/noser_prime_small.gd"),
    'noser_prime_tiny' : preload("res://scripts/enemies/noser_prime_tiny.gd"),
    'grumpy_prime_pile' : preload("res://scripts/enemies/grumpy_prime_pile.gd"),
    'grumpy_prime' : preload("res://scripts/enemies/grumpy_prime.gd"),
    'rainbow' : preload("res://scripts/enemies/grumpy_prime_rainbow.gd"),
    'nyan' : preload("res://scripts/enemies/grumpy_prime_nyan.gd"),
}

var enemy_difficulties = [
    [],
    ['lizard', 'snake', 'frog'],
    ['retarded_rat', 'fat_rat', 'jumping_rat'],
    ['spider', 'cockroach'],
    ['ant', 'wasp'],
    ['shia', 'dog'],
]

var enemies_list = {}

func _init_bag(bag):
    self.bag = bag

func spawn(name, map_position):
    var global_position = self.bag.room_loader.translate_position(map_position)
    return self.spawn_global(name, global_position)

func spawn_global(name, global_position):
    var new_enemy = self.enemy_templates[name].new(self.bag)
    new_enemy.spawn(global_position)
    self.add_enemy(new_enemy)
    return new_enemy

func reset():
    for enemy in self.enemies_list:
        self.enemies_list[enemy].detach()
    self.enemies_list.clear()

func add_enemy(enemy):
    self.enemies_list[enemy.get_instance_ID()] = enemy

func del_enemy(enemy):
    self.enemies_list.erase(enemy.get_instance_ID())
    if self.enemies_list.size() == 0:
        self.bag.room_loader.open_doors()
        self.bag.game_state.current_cell.clear = true

func get_enemies_near_object(object, attack_range, attack_direction, attack_width):
    var result = []
    for instance_id in self.enemies_list:
        if self.is_enemy_in_cone(self.enemies_list[instance_id], object, attack_range, attack_direction, attack_width):
            result.append(self.enemies_list[instance_id])

    return result

func is_enemy_in_cone(enemy, object, attack_range, attack_direction, attack_width):
    var enemy_position
    var object_position
    var position_delta
    var attack_vector
    var angle
    var melee_range = 3

    var distance = enemy.calculate_distance_to_object(object)

    if distance < melee_range:
        return true

    if distance < attack_range:
        enemy_position = enemy.get_pos()
        attack_vector = Vector2(attack_direction[0], attack_direction[1])
        object_position = object.get_pos()
        position_delta = Vector2(enemy_position.x - object_position.x, enemy_position.y - object_position.y)
        angle = attack_vector.angle_to(position_delta)

        if abs(angle) < attack_width:
            return true
    return false

func get_random_enemy_name(difficulty):
    randomize()
    var apropriate_enemies = self.enemy_difficulties[difficulty]
    return apropriate_enemies[randi() % apropriate_enemies.size()]

func get_enemy(type):
    for enemy in self.enemies_list:
        if self.enemies_list[enemy] extends self.enemy_templates[type]:
            return self.enemies_list[enemy]

    return null
