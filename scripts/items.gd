
var bag

var item_templates = {
    'cheese' : preload("res://scripts/items/cheese.gd"),
}

var enemies_list = {}

func _init_bag(bag):
    self.bag = bag

func spawn(name):
    var new_item = self.item_templates[name].new(self.bag)
    new_item.spawn()

    return new_item




