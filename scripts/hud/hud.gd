
var bag
var hud

var player_panel_template = preload("res://scripts/hud/player_panel.gd")

var player_panels = [
    null,
    null,
]

func _init_bag(bag):
    self.bag = bag
    self.hud = self.bag.root.get_node("hud")

func bind_player_panel(player_num):
    var panel = self.hud.get_node("player" + str(player_num + 1))
    self.player_panels[player_num] = self.player_panel_template.new(self.bag, panel)

    return self.player_panels[player_num]

func show():
    self.hud.show()
    self.hud.raise()

func hide():
    self.hud.hide()

func reset():
    for panel in self.player_panels:
        panel.reset()
