
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	self.connect("body_enter", self, "_on_Area2D_body_enter")


func _on_Area2D_body_enter( body ):
	print(get_node("Ninja").get_property_list())
