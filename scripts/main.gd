extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main ready")
	Game.reference_node = self
