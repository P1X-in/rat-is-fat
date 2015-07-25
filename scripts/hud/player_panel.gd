
var bag
var panel

func _init(bag, panel_node):
    self.bag = bag
    self.panel = panel_node

func show():
    self.panel.show()
    self.joined()

func hide():
    self.panel.hide()
    self.dead()

func joined():
    self.panel.get_node('dead').hide()
    self.panel.get_node('join').hide()
    self.panel.get_node('stats').show()

func dead():
    self.panel.get_node('dead').show()
    self.panel.get_node('join').hide()
    self.panel.get_node('stats').hide()