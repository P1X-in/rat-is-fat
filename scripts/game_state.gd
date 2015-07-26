
var bag

var game_in_progress = false
var current_room
var current_cell
var doors_open = true
var level = 0

var levels = [
    {'room_difficulty' : 1, 'rooms' : 6, 'pickup_rooms' : 1},
    {'room_difficulty' : 1, 'rooms' : 10, 'pickup_rooms' : 2},
    {'room_difficulty' : 2, 'rooms' : 10, 'pickup_rooms' : 2},
]

func _init_bag(bag):
    self.bag = bag

func reset():
    self.game_in_progress = false
    self.current_room = null
    self.current_cell = null
    self.doors_open = true
    self.level = 0