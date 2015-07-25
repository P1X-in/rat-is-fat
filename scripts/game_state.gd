
var bag

var game_in_progress = false
var current_room
var current_cell
var doors_open = true

func _init_bag(bag):
    self.bag = bag

func reset():
    self.game_in_progress = false
    self.current_room = null
    self.current_cell = null
    self.doors_open = true