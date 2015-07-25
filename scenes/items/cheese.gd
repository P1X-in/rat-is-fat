
extends RigidBody2D
# selects random chees omnomnom

var body

func _ready():
    self.set_mode(MODE_RIGID)
    self.body = self.get_node('body')
    self.body.set_frame(randi() % self.body.get_vframes())
    pass


