
var bag

var item_templates = {
    'cheese' : preload("res://scripts/items/cheese.gd"),
}

var enemies_list = {}

func _init_bag(bag):
    self.bag = bag

func spawn(name, map_position):
    var new_item = self.item_templates[name].new(self.bag)
    var global_position = self.bag.room_loader.translate_position(map_position)
    new_item.spawn(global_position)

    return new_item




