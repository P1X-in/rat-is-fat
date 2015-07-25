
var bag
var panel

var fat_bar = []
var power_bar = []

func _init(bag, panel_node):
    self.bag = bag
    self.panel = panel_node
    for i in range(0, 16):
        self.fat_bar.append(self.panel.get_node('stats/fat/progress' + str(i)))
        self.power_bar.append(self.panel.get_node('stats/power/progress' + str(i)))

func update_bar(bar, value, frame_offset):
    if value >= bar.size():
        value = bar.size() - 1
    for i in range(0, bar.size()):
        bar[i].show()
        if i == value:
            bar[i].set_frame(2 + frame_offset)
        elif i == value - 1:
            bar[i].set_frame(1 + frame_offset)
        elif i < value:
            bar[i].set_frame(0 + frame_offset)
        else:
            bar[i].hide()

func show():
    self.joined()

func hide():
    self.dead()

func joined():
    self.panel.get_node('dead').hide()
    self.panel.get_node('join').hide()
    self.panel.get_node('stats').show()

func dead():
    self.panel.get_node('dead').show()
    self.panel.get_node('join').hide()
    self.panel.get_node('stats').hide()