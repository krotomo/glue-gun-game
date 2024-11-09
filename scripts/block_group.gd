class_name BlockGroup
extends Node2D

enum Type { PLAYER, SOLID, WALL }

var block_group_scene = preload("res://scenes/block_group.tscn")
var accel = 3500
var max_speed = 400
var gravity = 1500
var max_fall_speed = 1000
var jump_speed = -550
var velocity = Vector2.ZERO
var remainder = Vector2.ZERO
const BLOCK_SIZE = 32


func _ready():
	for block in get_blocks():
		connect_block_signals(block)


func _process(delta):
	var category = get_category()
	if (category == Type.PLAYER):
		var direction = Input.get_axis("move_left", "move_right")
		velocity.x = move_toward(velocity.x, max_speed * direction, delta * accel)
		if (Input.is_action_just_pressed("jump") and is_on_ground()):
			velocity.y = jump_speed
	if (category != Type.WALL):
		velocity.y = move_toward(velocity.y, max_fall_speed, delta * gravity)
		move_x(velocity.x * delta)
		move_y(velocity.y * delta)


func connect_block_signals(block):
	block.create_connection.connect(on_connect)
	block.delete_connection.connect(on_disconnect)


func disconnect_block_signals(block):
	block.create_connection.disconnect(on_connect)
	block.delete_connection.disconnect(on_disconnect)


func get_category():
	var blocks = get_blocks()
	var hasPlayer = false
	var hasWall = false
	for block in blocks:
		if block.type == Block.Type.PLAYER:
			hasPlayer = true
		elif block.type == Block.Type.WALL:
			hasWall = true
	if hasWall:
		return Type.WALL
	if hasPlayer:
		return Type.PLAYER
	return Type.SOLID


func on_connect(this_connector, other_connector):
	this_connector.state = Connector.States.CONNECTED
	other_connector.state = Connector.States.CONNECTED
	this_connector.other = other_connector
	other_connector.other = this_connector
	var other_block_group = other_connector.get_parent().get_parent()
	if other_block_group != self:
		add_block_group_to_self(
			other_block_group, this_connector, other_connector)


func on_disconnect(connector):
	if !connector.other:
		return
	var this_block = connector.get_parent()
	var other_block = connector.other.get_parent()
	connector.other.state = Connector.States.IDLE
	connector.state = Connector.States.IDLE
	connector.other.other = null
	connector.other = null
	var queue = [other_block]
	var visited := {}
	while queue.size() > 0:
		var block = queue.pop_back()
		if visited.get(block):
			continue
		visited[block] = true
		var neighbors = [
			block.left.other,
			block.right.other,
			block.top.other,
			block.bottom.other
		]
		for neighbor in neighbors:
			if neighbor:
				queue.push_back(neighbor.get_parent())
	if !visited.get(this_block):
		var new_block_group = block_group_scene.instantiate()
		new_block_group.add_to_group("block_group")
		Game.reference_node.add_child(new_block_group)
		for block in visited.keys():
			disconnect_block_signals(block)
			new_block_group.connect_block_signals(block)
			block.call_deferred("reparent", new_block_group)


func add_block_group_to_self(block_group, this_connector, other_connector):
	var move = this_connector.global_position - other_connector.global_position
	var other_blocks = block_group.get_blocks()
	if get_category() == Type.WALL:
		for block in other_blocks:
			block.global_position += move
	else:
		for block in get_blocks():
			block.global_position -= move
	for block in other_blocks:
		block.call_deferred("reparent", self)
		connect_block_signals(block)
	block_group.queue_free()


func is_on_ground():
	return Game.collision_check(self, Vector2(0, 1))


func move_x(amount):
	remainder.x += amount
	var move = round(remainder.x)
	if move == 0:
		return
	remainder.x -= move
	var step = sign(move)
	var offset = Vector2(step, 0)
	var collision = false
	while !collision and move != 0:
		collision = Game.collision_check(self, offset)
		if !collision:
			global_position.x += step
			move -= step
	if collision:
		velocity.x = 0


func move_y(amount):
	remainder.y += amount
	var move = round(remainder.y)
	if move == 0:
		return
	remainder.y -= move
	var step = sign(move)
	var offset = Vector2(0, step)
	var collision = false
	while !collision and move != 0:
		collision = Game.collision_check(self, offset)
		if !collision:
			global_position.y += step
			move -= step
	if collision:
		velocity.y = 0


func rect2_from_position(pos):
	return Rect2i(
		pos.x - BLOCK_SIZE/2,
		pos.y - BLOCK_SIZE/2,
		BLOCK_SIZE,
		BLOCK_SIZE
	)


func get_blocks():
	return get_children().filter(func(x): return x is Block)
