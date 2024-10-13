class_name BlockGroup
extends Node2D


enum Group { PLAYER, WALL, SOLID }
@export var category : Group = Group.WALL
@export var connections : Array = []
var fixed = false
var accel = 2000
var max_speed = 200
var gravity = 1000
var max_fall_speed = 500
var jump_speed = -320
var velocity = Vector2.ZERO
var remainder = Vector2.ZERO
const BLOCK_SIZE = 16


func _ready():
	for child in get_children():
		if child is Block:
			child.connect("connect", on_connect)
			child.connect("disconnect", on_disconnect)


func _process(delta):
	if !fixed:
		if (category == Group.PLAYER):
			var direction = Input.get_axis("move_left", "move_right")
			velocity.x = move_toward(velocity.x, max_speed * direction, delta * accel)
			if (Input.is_action_just_pressed("jump") and is_on_ground()):
				velocity.y = jump_speed
		if (category != Group.WALL):
			velocity.y = move_toward(velocity.y, max_fall_speed, delta * gravity)
			move_x(velocity.x * delta)
			move_y(velocity.y * delta)


func on_connect(this_area, other_area, direction):
	var other_block_group = other_area.get_parent().get_parent()
	if other_block_group == self || other_block_group is not BlockGroup:
		return
	this_area.state = Connector.States.CONNECTED
	var block_a = this_area.get_parent()
	var block_b = other_area.get_parent()
	if other_block_group.category == Group.WALL:
		fixed = true
	elif category == Group.WALL:
		other_block_group.fixed = true
	else:
		if category == Group.PLAYER || other_block_group.category == Group.SOLID:
			add_block_group_to_self(other_block_group, block_a, block_b)
		else:
			other_block_group.add_block_group_to_self(self, block_a, block_b)


func on_disconnect(block, direction):
	var blocks = get_children().filter(func(x): x is Block)
	print(blocks)


func add_block_group_to_self(block_group, block_a, block_b):
	for child in block_group.get_children():
		if child is Block:
			child.call_deferred("reparent", self)
			child.connect("connect", on_connect)
			child.connect("disconnect", on_disconnect)
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
			position.x += step
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
			position.y += step
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
