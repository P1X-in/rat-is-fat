
var bag

var enemy_templates = {
    'shia' : preload("res://scripts/enemies/shia.gd")
}

var enemies_list = {}

func _init_bag(bag):
    self.bag = bag

func spawn(name):
    var new_enemy = self.enemy_templates[name].new(self.bag)
    new_enemy.spawn()
    self.add_enemy(new_enemy)

    return new_enemy

func reset():
    self.enemies_list.clear()

func add_enemy(enemy):
    self.enemies_list[enemy.get_instance_ID()] = enemy

func del_enemy(enemy):
    self.enemies_list.erase(enemy.get_instance_ID())

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
    var positoin_delta_y
    var angle
    if enemy.calculate_distance_to_object(object) < attack_range:
        enemy_position = enemy.get_pos()
        object_position = object.get_pos()
        position_delta_x = enemy_position.x - object_position.x
        positoin_delta_y = enemy_position.y - object_position.y
        angle = atan2(position_delta_x * attack_direction[1] - positoin_delta_y * attack_direction[0], position_delta_x * attack_direction[0] + positoin_delta_y * attack_direction[1] )
        if abs(angle) < attack_width:
            return true
    return false


