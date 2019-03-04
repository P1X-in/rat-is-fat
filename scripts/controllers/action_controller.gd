
var bag

var game_board = preload("res://scenes/game_board.xscn").instance()
var tilemap
var z_index

var intro_screen
var button1
var button2
var end_game_labels
var end_game_win
var end_game_lose


var idle_counter = 0
const IDLE_TIMEOUT = 60

func _init_bag(bag):
    self.bag = bag
    self.tilemap = self.game_board.get_node('level/TileMap/')
    self.z_index = self.game_board.get_node('z_index')

    self.intro_screen = self.bag.root.get_node('logo')
    self.button1 = self.intro_screen.get_node('center/p1')
    self.button2 = self.intro_screen.get_node('center/p2')
    self.end_game_labels = self.intro_screen.get_node('center/game_over')
    self.end_game_win = self.end_game_labels.get_node('win')
    self.end_game_lose = self.end_game_labels.get_node('lose')

    self.bag.timers.set_timeout(1, self, "game_idle_tick")

func start_game():
    self.bag.game_state.game_in_progress = true
    self.bag.root.add_child(self.game_board)
    self.bag.map.generate_map(self.bag.game_state.level)
    self.bag.map.switch_to_cell(self.bag.map.start_cell)
    self.bag.hud.show()

    self.intro_screen.hide()
    self.bag.scoreboard.hide()

func end_game(win=false, timeout=false):
    self.bag.game_state.current_cell.detach_persistent_objects()
    self.bag.game_state.game_in_progress = false
    self.bag.players.remove_remaining_players()
    self.bag.root.remove_child(self.game_board)
    self.bag.hud.hide()
    self.bag.reset()

    self.intro_screen.hide()
    self.bag.scoreboard.show(win, timeout)

func next_level(next):
    var level_settings
    if next == 'next':
        self.bag.game_state.level = self.bag.game_state.level + 1
        level_settings = self.bag.game_state.levels[self.bag.game_state.level]
        self.bag.map.generate_map(self.bag.game_state.level)
        self.bag.map.switch_to_cell(self.bag.map.start_cell)
        self.bag.players.move_to_entry_position('initial')
    elif next == 'end':
        self.end_game(true, false)

func attach_object(object):
    self.z_index.add_child(object)

func detach_object(object):
    self.z_index.remove_child(object)


func game_idle_tick():
    if not self.bag.game_state.game_in_progress:
        self.idle_counter = 0
    else:
        self.idle_counter = self.idle_counter + 1

    if self.idle_counter > self.IDLE_TIMEOUT:
        self.end_game(false, true)

    self.bag.timers.set_timeout(1, self, "game_idle_tick")