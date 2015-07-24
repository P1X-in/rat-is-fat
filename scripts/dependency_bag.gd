
var root

var game_state = preload("res://scripts/game_state.gd").new()
var action_controller = preload("res://scripts/controllers/action_controller.gd").new()

var input = preload("res://scripts/input/input.gd").new()
var players = preload("res://scripts/players.gd").new()
var processing = preload("res://scripts/processing.gd").new()

func _init(root_node):
    self.root = root_node
    self.game_state._init_bag(self)
    self.input._init_bag(self)
    self.players._init_bag(self)
    self.processing._init_bag(self)
    self.action_controller._init_bag(self)
