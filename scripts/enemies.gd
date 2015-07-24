
var bag

var enemy_templates = {
    'shia' : preload("res://scripts/enemies/shia.gd")
}

func _init_bag(bag):
    self.bag = bag

func spawn(name):
    var new_enemy = self.enemy_templates[name].new(self.bag)
    new_enemy.spawn()
