
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	self.connect("body_enter", self, "_on_light_body_enter")

func _on_light_body_enter (body):
	if(body.get_name() == "Ninja"):
		body.take_light()
		body.set_last_window(self)