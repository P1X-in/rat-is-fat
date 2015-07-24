
var bag

func _ready():
    self.bag = preload("res://scripts/dependency_bag.gd").new(self)
    self.set_process_input(true)

func _input(event):
    self.bag.input.handle_event(event)