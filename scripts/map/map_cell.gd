
var bag

var x
var y

var template_name

var north = null
var south = null
var east = null
var west = null

var clear = false
var items = null

func _init(bag):
    self.bag = bag

func has_free_connections():
    return self.north == null || self.south == null || self.east == null || self.west == null