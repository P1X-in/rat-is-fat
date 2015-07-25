
var bag

var enemy_templates = {
    'shia' : preload("res://scripts/enemies/shia.gd")
}

var enemies_list = {}

func _init_bag(bag):
    self.bag = bag

func spawn(name, map_position):
    var new_enemy = self.enemy_templates[name].new(self.bag)
    var global_position = self.bag.room_loader.translate_position(map_position)
    new_enemy.spawn(global_position)
    self.add_enemy(new_enemy)

    return new_enemy

func reset():
    self.enemies_list.clear()

func add_enemy(enemy):
    self.enemies_list[enemy.get_instance_ID()] = enemy

func del_enemy(enemy):
    self.enemies_list.erase(enemy.get_instance_ID())
    if self.enemies_list.size() == 0:
        self.bag.room_loader.open_doors()

func get_enemies_near_object(object, attack_range, attack_direction, attack_width):
    var result = []
    for instance_id in self.enemies_list:
        if self.is_enemy_in_cone(self.enemies_list[instance_id], object, attack_range, attack_direction, attack_width):
            result.append(self.enemies_list[instance_id])

    return result

func is_enemy_in_cone(enemy, object, attack_range, attack_direction, attack_width):
    var enemy_position
    var object_position
    var position_delta_x
    var position_delta_y
    var angle
    if enemy.calculate_distance_to_object(object) < attack_range:
        enemy_position = enemy.get_pos()
        object_position = object.get_pos()
        position_delta_x = enemy_position.x - object_position.x
        position_delta_y = enemy_position.y - object_position.y
        angle = atan2(position_delta_x * attack_direction[1] - position_delta_y * attack_direction[0], position_delta_x * attack_direction[0] + position_delta_y * attack_direction[1] )
        if abs(angle) < attack_width:
            return true
    return false





