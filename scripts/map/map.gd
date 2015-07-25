
var bag

var map = []
var cells = []
var start_cell

var cell_template = preload("res://scripts/map/map_cell.gd")

func _init_bag(bag):
    self.bag = bag
    self.reset_map()

func reset_map():
    self.map = [
        [null, null, null, null, null, null, null, null, null],
        [null, null, null, null, null, null, null, null, null],
        [null, null, null, null, null, null, null, null, null],
        [null, null, null, null, null, null, null, null, null],
        [null, null, null, null, null, null, null, null, null],
        [null, null, null, null, null, null, null, null, null],
        [null, null, null, null, null, null, null, null, null],
        [null, null, null, null, null, null, null, null, null],
        [null, null, null, null, null, null, null, null, null],
    ]
    self.cells = []
    self.start_cell = self.add_cell('start', 5, 5)

func add_cell(room_template_name, x, y):
    var cell = self.cell_template.new(self.bag)
    cell.x = x
    cell.y = y
    cell.template_name = room_template_name
    self.map[y][x] = cell
    self.connect_room(cell)
    return cell

func connect_room(cell):
    self.connect_room_cell(cell, cell.x, cell.y - 1, 'north')
    self.connect_room_cell(cell, cell.x, cell.y + 1, 'south')
    self.connect_room_cell(cell, cell.x + 1, cell.y, 'east')
    self.connect_room_cell(cell, cell.x - 1, cell.y, 'west')

func connect_room_cell(cell, x, y, direction):
    if x < 0 || x >= self.map[0].size() || y < 0 || y >= self.map.size() || self.map[y][x] == null:
        return
    var neighbour_cell = self.map[y][x]
    if direction == 'north':
        cell.north = neighbour_cell
        neighbour_cell.south = cell
    elif direction == 'south':
        cell.south = neighbour_cell
        neighbour_cell.north = cell
    elif direction == 'east':
        cell.east = neighbour_cell
        neighbour_cell.west = cell
    elif direction == 'west':
        cell.west = neighbour_cell
        neighbour_cell.east = cell

func generate_map(difficulty):
    self.reset_map()

func load_current_cell():
    self.bag.game_state.current_cell = self.start_cell
    self.bag.room_loader.load_room(self.start_cell)
