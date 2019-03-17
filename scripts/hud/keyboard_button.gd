extends TextureButton

var label_node
var my_value
var bag

func _ready():
    self.label_node = self.get_node("Label")
    self.my_value = self.label_node.get_text()
    self.connect("pressed", self, "_on_click")

func _on_click():
    self.bag = self.get_node("/root/root").bag
    self.bag.scoreboard.add_tag_query_character(self.my_value)
