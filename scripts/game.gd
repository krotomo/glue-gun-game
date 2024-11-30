extends Node


var reference_node : Node2D = null
var nearest_connector : Connector = null
var next_block_id = 0


func _process(_delta):
	if !reference_node:
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
			nearest_connector.disconnect_connector()


func block_id():
	var result = next_block_id
	next_block_id += 1
	return result
