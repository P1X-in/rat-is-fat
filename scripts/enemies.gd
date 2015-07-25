
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

func get_enemies_near_object(object, attack_range):
    var result = []
    for instance_id in self.enemies_list:
        if self.enemies_list[instance_id].calculate_distance_to_object(object) < attack_range:
            result.append(self.enemies_list[instance_id])

    return result




