
var bag
var camera

var zoom

func _init_bag(bag):
    self.bag = bag
    self.camera = self.bag.root.camera
    self.zoom = self.camera.get_zoom()