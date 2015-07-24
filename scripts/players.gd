
var bag

var player_template = preload("res://scripts/player.gd")
var players = []

func _init_bag(bag):
    self.bag = bag
    self.bind_players()
    self.bind_processing()

func bind_players():
    self.players = [
        self.player_template.new(self.bag),
        self.player_template.new(self.bag),
        self.player_template.new(self.bag),
        self.player_template.new(self.bag),
    ]

    self.players[0].bind_gamepad(0)
    self.players[1].bind_gamepad(1)
    self.players[2].bind_gamepad(2)
    self.players[3].bind_gamepad(3)

func bind_processing():
    for player in self.players:
        self.bag.processing.register(player)
