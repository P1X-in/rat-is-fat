
const SCOREBOARD_FILE_PATH = 'user://scoreboard.rif'

var bag
var scoreboard_node

func _init_bag(bag):
    self.bag = bag
    self.scoreboard_node = self.bag.root.get_node("scoreboard")

func show(win, timeout):
    self.scoreboard_node.show()

func hide():
    self.scoreboard_node.hide()
