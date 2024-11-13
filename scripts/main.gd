extends Node2D

@onready var block_groups = []


# Called when the node enters the scene tree for the first time.
func _ready():
	Game.reference_node = self
	var block_list = get_tree().get_nodes_in_group("block")
	for block in block_list:
		var group = BlockGroup.new()
		group.blocks.append(block)
		block_groups.append(group)


func join_groups(group_a: BlockGroup, group_b: BlockGroup):
	group_a.blocks.append_array(group_b.blocks)
	group_b.queue_free()


func _process(_delta):
	pass
