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


func get_block_group(block: Block) -> BlockGroup:
	for group in block_groups:
		if block in group.blocks:
			return group
	return null


func add_connection(connector_a: Connector, connector_b: Connector, direction: Connector.Direction):
	if connector_b not in connector_a.get_overlapping_areas():
		return
	var block_a = connector_a.get_parent()
	var block_b = connector_b.get_parent()
	var block_group_a = get_block_group(block_a)
	var block_group_b = get_block_group(block_b)
	if block_group_a != block_group_b:
		block_group_a.merge(block_group_b)
		block_groups.erase(block_group_b)
	connector_a.other = connector_b
	connector_b.other = connector_a
	connector_a.state = Connector.States.CONNECTED
	connector_b.state = Connector.States.CONNECTED


func delete_connection(connector: Connector):
	var block_a = connector.get_parent()
	var block_b = connector.other.get_parent()
	var block_group = get_block_group(block_a)
	connector.other.other = null
	connector.other.state = Connector.States.IDLE
	connector.other = null
	connector.state = Connector.States.IDLE

	# Use BFS to find all connected blocks starting from block_a
	var queue = [block_a]
	var visited = {block_a: true}
	var connected_blocks = [block_a]
	
	while queue.size() > 0:
		var current = queue.pop_front()
		for dir in [current.left, current.right, current.up, current.down]:
			if dir.other == null:
				continue
			var next_block = dir.other.get_parent()
			if next_block in visited:
				continue
			visited[next_block] = true
			queue.append(next_block)
			connected_blocks.append(next_block)
	
	# If block_b is not in connected blocks, create new group
	if block_b not in visited:
		var new_group = BlockGroup.new()
		for block in block_group.blocks:
			if block not in visited:
				new_group.blocks.append(block)
				block_group.blocks.erase(block)
		block_groups.append(new_group)
