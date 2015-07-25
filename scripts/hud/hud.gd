
var bag
var hud

var player_panel_template = preload("res://scripts/hud/player_panel.gd")

var player_panels = [
    null,
    null,
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

func hide():
    self.hud.hide()

