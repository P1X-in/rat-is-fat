
var bag

var player_template = preload("res://scripts/player.gd")
var players = []

func _init_bag(bag):
    self.bag = bag
    self.bind_players()

func bind_players():
    self.players = [
        self.player_template.new(self.bag, 0),
        self.player_template.new(self.bag, 1),
        self.player_template.new(self.bag, 2),
        self.player_template.new(self.bag, 3),
    ]
    self.players[0].bind_keyboard_and_mouse()

func move_to_entry_position(name):
    for player in self.players:
        player.move_to_entry_position(name)