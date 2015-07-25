extends "res://scripts/items/abstract_item.gd"

var body

func _init(bag).(bag):
    self.avatar = preload("res://scenes/items/medicals.xscn").instance()
    self.body = self.avatar.get_node('body')
    self.randomize_frame()
    self.power_up_type = POWER_UP_TYPE_POWER

func randomize_frame():
    randomize()
    self.body.set_frame(0)
