extends Control

const LETTER_SIZE = 7
const MARGINS = 20
const HEIGHT = 30

var patch_bubble
var label

func _ready():
    self.patch_bubble = self.get_node("patch")
    self.label = self.get_node("patch/label")

func set_text(text):
    var text_width = self.LETTER_SIZE * length(text) + self.MARGINS

    var size = Vector2(text_width, self.HEIGHT)
    var position = Vector2(text_width, self.HEIGHT) / 2

    self.patch_bubble.set_pos(position)
    self.patch_bubble.set_size(size)
    self.label.set_text(text)
    self.label.set_size(size)
