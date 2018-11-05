
var bag

var minimap

var size = Vector2(9, 9)

const VISITED = 0
const KNOWN = 1
const CURRENT = 2
const BOSS = 3

func _init_bag(bag):
    self.bag = bag
    self.minimap = self.bag.root.get_node('hud/minimap/TileMap')


func clear():
    for x in range(0, self.size.x):
        for y in range(0, self.size.y):
            self.minimap.set_cell(x, y, -1)

func redraw(map):
    self.clear()

    var cell

    for x in range(0, self.size.x):
        for y in range(0, self.size.y):
            cell = map[y][x]

            if cell == null:
                continue

            if cell.is_boss_room() and cell.known:
                self.minimap.set_cell(x, y, self.BOSS)
            elif cell.visited:
                self.minimap.set_cell(x, y, self.VISITED)
            elif cell.known:
                self.minimap.set_cell(x, y, self.KNOWN)

    self.minimap.set_cell(self.bag.game_state.current_cell.x, self.bag.game_state.current_cell.y, self.CURRENT)


func mark_minimap(cell):
    cell.visited = true
    if cell.north != null:
        cell.north.known = true
    if cell.south != null:
        cell.south.known = true
    if cell.east != null:
        cell.east.known = true
    if cell.west != null:
        cell.west.known = true
