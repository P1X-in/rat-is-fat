extends "res://scripts/map/rooms/abstract_room.gd"

func _init():
    self.room = [
        [   4,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   6],
        [   7,   0, 106,   2, 107,   0, 106, 107, 107,   2,   0, 106,   1, 107,   2,   2,   2, 106, 106,   9],
        [   7, 106, 107, 106,   0, 106, 106,   1, 106, 107,   0, 107, 107,   2,   2,   2, 106,   1,   3,   9],
        [   7,   1, 107,   2, 106, 107,   0, 107,   2,   2, 106, 106, 107, 106,   2, 107,   2,   0, 106,   9],
        [   7,   2, 107, 106,   2, 107,   1, 106, 106,   0, 107, 107,   0,   2, 107, 107, 106,   1, 106,   9],
        [   7, 106, 106, 107, 106, 107,   2, 107,   2, 107, 106,   2, 107, 107,   2,   1, 106, 106,   2,   9],
        [   7,   2,   2, 106, 106,   1, 107, 107, 107, 107,   2, 107,   0,   0, 106, 107, 107,   1,   1,   9],
        [   7,   0, 106, 106, 106, 106, 106,   0,   1,   0, 107, 107,   2, 106, 107,   0,   2,   2,   2,   9],
        [   7, 106,   2, 107, 106,   2,   2,   0,   2, 106,   0,   2,   2, 107,   0, 106,   2,   2, 106,   9],
        [  12,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  10,  11],
    ]

    self.items = [
        [7, 5, 'medicals'],
        [8, 5, 'medicals'],
    ]