

var bag
var tilemap
var room_max_size = Vector2(20, 12)
var side_offset = 3

var spawns = {
    'initial' : Vector2(8, 5),
    'north' : Vector2(8, 1),
    'south' : Vector2(8, 9),
    'east' : Vector2(15, 5),
    'west' : Vector2(1, 5),
}

var room_templates = {
    'start' : preload("res://scripts/map/rooms/start_room.gd"),
    'easy1' : preload("res://scripts/map/rooms/easy1_room.gd"),
}

var difficulty_templates = [
    ['start'],
    ['easy1'],
]

func _init_bag(bag):
    self.bag = bag
    self.tilemap = self.bag.action_controller.tilemap

func load_room(template_name):
    self.clear_space()
    self.bag.game_state.current_room = self.room_templates[template_name].new()
    self.apply_room_data(self.bag.game_state.current_room.room)
    self.spawn_enemies(self.bag.game_state.current_room.enemies)
    self.spawn_items(self.bag.game_state.current_room.items)

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

func spawn_enemies(enemies):
    var position = Vector2(0, 0)
    for enemy_data in enemies:
        position.x = enemy_data[0] + self.side_offset
        position.y = enemy_data[1]
        self.bag.enemies.spawn(enemy_data[2], position)

func spawn_items(items):
    var position = Vector2(0, 0)
    for item_data in items:
        position.x = item_data[0] + self.side_offset
        position.y = item_data[1]
        self.bag.items.spawn(item_data[2], position)

func get_spawn_position(spawn_name):
    var position = self.bag.room_loader.spawns[spawn_name]
    position.x = position.x + self.side_offset
    return self.translate_position(position)

func translate_position(position):
    return self.tilemap.map_to_world(position)