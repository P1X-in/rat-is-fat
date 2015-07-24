
var bag

var ready = false

var objects = []

func _init_bag(bag):
    self.bag = bag
    self.ready = true

func register(object):
    self.objects.append(object)

func process(delta):
    if not self.ready:
        return

    for object in self.objects:
        if object.is_processing:
            object.process(delta)