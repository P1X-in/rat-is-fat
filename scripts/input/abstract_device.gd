
var handled_input_types = []
var device_id = null

func can_handle(event):
    for type in self.handled_input_types:
        if event.type == type:
            if self.device_id != null:
                if event.device == self.device_id:
                    return true
            else:
                return true
    return false

