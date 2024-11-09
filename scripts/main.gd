extends Node2D

@onready var blocks = Dictionary()
@onready var component = Dictionary()
@onready var components = Dictionary()
@onready var connections = Dictionary()
var next_component_id = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Game.reference_node = self
	var block_list = get_tree().get_nodes_in_group("block")
	for block in block_list:
		blocks[block.id] = block
		var new_component = [block.id]
		components[next_component_id] = new_component
		next_component_id += 1
	for block in block_list:
		var connectors = [block.left, block.right, block.top, block.bottom]
		for connector in connectors:
			if connector.block != null:
				if connections[block.id] == null:
					connections[block.id] = Dictionary()
				if connections[connector.block.id]:
					connections[connector.block.id] = Dictionary()
				connections[block.id][connector.block.id] = true
				connections[connector.block.id][block.id] = true


func _process(_delta):
	pass
