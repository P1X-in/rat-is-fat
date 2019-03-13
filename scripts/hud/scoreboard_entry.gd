extends Control

var player_0_head
var player_0_score
var player_1_head
var player_1_score
var tag

func fill(tag, player_0_score, player_1_score):
    self.player_0_head = self.get_node("player0head")
    self.player_0_score = self.get_node("player0score")
    self.player_1_head = self.get_node("player1head")
    self.player_1_score = self.get_node("player1score")
    self.tag = self.get_node("tag")

    self.player_0_score.set_text(str(player_0_score))

    if player_1_score != null:
        self.player_1_head.show()
        self.player_1_score.set_text(str(player_1_score))
    else:
        self.player_1_head.hide()
        self.player_1_score.hide()

    self.tag.set_text(tag)
