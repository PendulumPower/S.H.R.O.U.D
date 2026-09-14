extends Camera3D


var time = 0.0;

func _process(delta):
	time += delta;
	self.position.y = sin(time * 0.75) * 0.15 + 2.75;
