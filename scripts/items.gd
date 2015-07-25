
var bag

var enemy_templates = {
    'cheese' : preload("res://scripts/items/cheese.gd"),
    'pill' : preload("res://scripts/items/pill.gd")
}

var enemies_list = {}

func _init_bag(bag):
    self.bag = bag

func spawn(name):
    var new_enemy = self.enemy_templates[name].new(self.bag)
    new_enemy.spawn()
    self.add_enemy(new_enemy)

    return new_enemy




