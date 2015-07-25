
var bag
var panel

func _init(bag, panel_node):
    self.bag = bag
    self.panel = panel_node

func show():
    self.panel.show()

func hide():
    self.panel.hide()
