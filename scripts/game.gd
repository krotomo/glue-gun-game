extends Node


const BLOCK_SIZE = 16
var reference_node : Node2D = null
var nearest_connector : Connector = null


func _process(_delta):
	if reference_node:
		var mouse_position = reference_node.get_global_mouse_position()
		var min_distance = 8
		var selected_connector = null
		var connectors = get_tree().get_nodes_in_group("clickable")
		for connector in connectors:
			var distance = (
				mouse_position - connector.global_position).length()
			if distance < 8 and connector.state == Connector.States.CONNECTED:
				selected_connector = connector
				break
			if distance < min_distance:
				min_distance = distance
				selected_connector = connector
		nearest_connector = selected_connector
	
	if Input.is_action_just_pressed("select") and nearest_connector:
		if nearest_connector.state == Connector.States.IDLE:
			nearest_connector.state = Connector.States.READY
		elif nearest_connector.state == Connector.States.READY:
			nearest_connector.state = Connector.States.IDLE
		else:
			nearest_connector.disconnect_connector()


func collision_check(this_block_group, offset):
	var other_block_groups = get_tree().get_nodes_in_group("block_group").filter(
		func(block_group): return block_group != this_block_group).map(
			func(block_group): return block_group.find_children(
				"*", "res://scripts/block.gd"
			).map(
				func(block): return rect2_from_position(
					block.global_position
				)
			)
		)
	var blocks = this_block_group.find_children("*", "res://scripts/block.gd").map(
		func(block):
			var new_position = block.global_position + offset
			return rect2_from_position(new_position)
	)
	var collision = false
	for block in blocks:
		for other_block_group in other_block_groups:
			for other_block in other_block_group:
				if block.intersects(other_block):
					collision = true
	return collision


func rect2_from_position(pos):
	return Rect2i(
		pos.x - BLOCK_SIZE/2,
		pos.y - BLOCK_SIZE/2,
		BLOCK_SIZE,
		BLOCK_SIZE
	)
