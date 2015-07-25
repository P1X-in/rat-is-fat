
var bag

var game_board = preload("res://scenes/game_board.xscn").instance()
var tilemap

func _init_bag(bag):
    self.bag = bag
    self.tilemap = self.game_board.get_node('level/tilemap')

func start_game():
    self.bag.game_state.game_in_progress = true
    self.bag.root.add_child(self.game_board)
    var shia = self.bag.enemies.spawn('shia')

func end_game():
    self.bag.game_state.game_in_progress = false
    self.bag.root.remove_child(self.game_board)

func attach_object(object):
    self.game_board.add_child(object)

func detach_object(object):
    self.game_board.remove_child(object)