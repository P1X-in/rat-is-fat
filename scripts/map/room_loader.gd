

var bag
var tilemap
var room_max_size = Vector2(20, 12)
var side_offset = 3

var room_templates = {
    'start' : preload("res://scripts/map/rooms/start_room.gd")
}

func _init_bag(bag):
    self.bag = bag
    self.tilemap = self.bag.action_controller.tilemap

func load_room(template_name):
    self.clear_space()
    self.bag.game_state.current_room = self.room_templates[template_name].new()
    self.apply_room_data(self.bag.game_state.current_room.room)

func clear_space():
    for x in range(self.room_max_size.x):
        for y in range(self.room_max_size.y):
            self.tilemap.set_cell(x, y, -1)

func apply_room_data(data):
    var row
    for y in range(0, data.size()):
        row = data[y]
        for x in range(0, row.size()):
            self.tilemap.set_cell(x + self.side_offset, y, data[y][x])
