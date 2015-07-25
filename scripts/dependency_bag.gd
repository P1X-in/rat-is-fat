
var root

var game_state = preload("res://scripts/game_state.gd").new()
var action_controller = preload("res://scripts/controllers/action_controller.gd").new()

var input = preload("res://scripts/input/input.gd").new()
var players = preload("res://scripts/players.gd").new()
var enemies = preload("res://scripts/enemies.gd").new()
var processing = preload("res://scripts/processing.gd").new()
var camera = preload("res://scripts/camera.gd").new()
var map = preload("res://scripts/map/map.gd").new()
var room_loader = preload("res://scripts/map/room_loader.gd").new()

func _init(root_node):
    self.root = root_node
    self.game_state._init_bag(self)
    self.input._init_bag(self)
    self.camera._init_bag(self)
    self.players._init_bag(self)
    self.enemies._init_bag(self)
    self.processing._init_bag(self)
    self.map._init_bag(self)
    self.room_loader._init_bag(self)
    self.action_controller._init_bag(self)
