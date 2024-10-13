class_name Block
extends Node2D
signal connect(this_area, other_area, direction)
signal disconnect(block, direction)


func _on_left_area_entered(area):
	if $Left.state == Connector.States.READY and area is Connector:
		connect.emit($Left, area, "left")


func _on_right_area_entered(area):
	if $Right.state == Connector.States.READY and area is Connector:
		connect.emit($Right, area, "right")


func _on_top_area_entered(area):
	if $Top.state == Connector.States.READY and area is Connector:
		connect.emit($Top, area, "top")


func _on_bottom_area_entered(area):
	if $Bottom.state == Connector.States.READY and area is Connector:
		connect.emit($Bottom, area, "bottom")


func _on_left_disconnect():
	disconnect.emit(self, "left")


func _on_right_disconnect():
	disconnect.emit(self, "right")


func _on_top_disconnect():
	disconnect.emit(self, "top")


func _on_bottom_disconnect():
	disconnect.emit(self, "bottom")
