extends Node2D

@onready var block_groups : Array[BlockGroup] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main ready")
	Game.reference_node = self
	var block_list = get_tree().get_nodes_in_group("block")
	for block in block_list:
		var group = BlockGroup.new()
		group.blocks.append(block)
		block_groups.append(group)


func _physics_process(delta):
	for group in block_groups:
		group.process(delta)
	

func add_block(block: Block):
	var group = BlockGroup.new()
	group.blocks.append(block)
	block_groups.append(group)


func collision_check(block_group_a: BlockGroup, offset: Vector2):
	for block_a in block_group_a.blocks:
		for group in block_groups:
			if group == block_group_a:
				continue
			for block_b in group.blocks:
				var new_position = block_a.global_position + offset
				if (
					new_position.x + Block.SIZE / 2 > block_b.global_position.x - Block.SIZE / 2 and 
					new_position.x - Block.SIZE / 2 < block_b.global_position.x + Block.SIZE / 2 and 
					new_position.y + Block.SIZE / 2 > block_b.global_position.y - Block.SIZE / 2 and 
					new_position.y - Block.SIZE / 2 < block_b.global_position.y + Block.SIZE / 2
				):
					return true
	return false


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
	print("Adding connection between ", block_a, " and ", block_b)
	var block_group_a = get_block_group(block_a)
	var block_group_b = get_block_group(block_b)
	if block_group_a != block_group_b:
		print("Merged block groups:")
		print("- Group A blocks: ", block_group_a.blocks)
		print("- Group B blocks: ", block_group_b.blocks)
		var moving_group
		if (
			block_group_a.get_type() == BlockGroup.Type.WALL or (
				block_group_a.get_type() == BlockGroup.Type.PLAYER and block_group_b.get_type() == BlockGroup.Type.SOLID
			)
		):
			moving_group = block_group_b
		else:
			moving_group = block_group_a
		
		var offset
		if moving_group == block_group_a:
			offset = connector_b.global_position - connector_a.global_position
		else:
			offset = connector_a.global_position - connector_b.global_position

		for block in moving_group.blocks:
			block.global_position += offset

		block_group_a.merge(block_group_b)
		block_groups.erase(block_group_b)
		print("- Resulting merged group: ", block_group_a.blocks)
	connector_a.other = connector_b
	connector_b.other = connector_a
	connector_a.state = Connector.States.CONNECTED
	connector_b.state = Connector.States.CONNECTED


func delete_connection(connector: Connector):
	var block_a = connector.get_parent()
	var block_b = connector.other.get_parent()
	print("Deleting connection between ", block_a, " and ", block_b)
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
		print("Visiting ", current)
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
		print("Split into separate block groups:")
		print("- Original group: ", block_group.blocks)
		var new_group = BlockGroup.new()
		var blocks_to_move = []
		for block in block_group.blocks:
			if block not in visited:
				blocks_to_move.append(block)
		for block in blocks_to_move:
			new_group.blocks.append(block)
			block_group.blocks.erase(block)
		block_groups.append(new_group)
		print("- Group 1 after split: ", block_group.blocks)
		print("- Group 2 after split: ", new_group.blocks)
