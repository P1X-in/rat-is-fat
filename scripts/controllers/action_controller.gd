
var bag

var game_board = preload("res://scenes/game_board.xscn").instance()
var tilemap

func _init_bag(bag):
    self.bag = bag
    self.tilemap = self.game_board.get_node('level/TileMap')

func start_game():
    self.bag.game_state.game_in_progress = true
    self.bag.root.add_child(self.game_board)
    self.bag.map.generate_map(1, 6)
    self.bag.map.load_current_cell()

func end_game():
    self.bag.game_state.game_in_progress = false
    self.bag.root.remove_child(self.game_board)

func attach_object(object):
    self.game_board.add_child(object)

func detach_object(object):
    self.game_board.remove_child(object)