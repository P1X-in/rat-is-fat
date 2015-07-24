
var root

var input = preload("res://scripts/input/input.gd").new()

func _init(root_node):
    self.root = root_node
    self.input._init_bag(self)
