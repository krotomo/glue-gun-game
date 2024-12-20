extends Node


var reference_node : Node2D = null
var nearest_connector : Connector = null
var next_block_id = 0


func _process(_delta):
	if !get_current_level():
		return
	var mouse_position = reference_node.get_global_mouse_position()
	var min_distance = 8
	var selected_connector = null
	var connectors = get_tree().get_nodes_in_group("connector")
	for connector in connectors:
		var distance = (
			mouse_position - connector.global_position).length()
		if distance < min_distance:
			min_distance = distance
			selected_connector = connector
		elif connector.state == Connector.States.CONNECTED\
				and distance < min_distance + 1:
			selected_connector = connector
	nearest_connector = selected_connector

	if Input.is_action_just_pressed("select") and nearest_connector:
		if nearest_connector.state == Connector.States.IDLE:
			nearest_connector.state = Connector.States.READY
		elif nearest_connector.state == Connector.States.READY:
			nearest_connector.state = Connector.States.IDLE
		else:
			get_current_level().delete_connection(nearest_connector)


func get_current_level():
	return reference_node.get_child(0) if reference_node and reference_node.get_child_count() > 0 else null


func block_id():
	var result = next_block_id
	next_block_id += 1
	return result


func switch_scene(scene : PackedScene):
	print("Switching to new level")
	if reference_node.get_child_count() > 0:
		var current_level = reference_node.get_child(0)
		current_level.block_groups.clear()
		current_level.queue_free()
	var new_level = scene.instantiate()
	reference_node.add_child(new_level)
