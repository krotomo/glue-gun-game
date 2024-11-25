class_name BlockGroup
extends RefCounted

enum Type { PLAYER, SOLID, WALL }

const GRAVITY = 1000
const ACCELERATION = 2500
const MAX_SPEED = 250
const JUMP_SPEED = 450

var blocks = []
var velocity : Vector2 = Vector2.ZERO
var remainder : Vector2 = Vector2.ZERO


func process(delta: float):
	if get_type() == Type.WALL:
		velocity = Vector2.ZERO
		return
	velocity.y += GRAVITY * delta
	if get_type() == Type.PLAYER:
		if Input.is_action_pressed("move_right"):
			velocity.x = move_toward(velocity.x, MAX_SPEED, ACCELERATION * delta)
		elif Input.is_action_pressed("move_left"):
			velocity.x = move_toward(velocity.x, -MAX_SPEED, ACCELERATION * delta) 
		else:
			velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		
		if Input.is_action_just_pressed("jump") and Game.reference_node.collision_check(self, Vector2(0, 1)):
			velocity.y = -JUMP_SPEED
	elif get_type() == Type.SOLID:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
	move_x(velocity.x * delta)
	move_y(velocity.y * delta)

func move_x(delta: float):
	var amount = delta + remainder.x
	var move = floor(abs(amount))
	remainder.x = amount - (move * sign(amount))
	while move > 0:
		if Game.reference_node.collision_check(self, Vector2(sign(amount), 0)):
			velocity.x = 0
			break
		move -= 1
		for block in blocks:
			block.global_position.x += sign(amount)


func move_y(delta: float):
	var amount = delta + remainder.y
	var move = floor(abs(amount))
	remainder.y = amount - (move * sign(amount))
	while move > 0:
		if Game.reference_node.collision_check(self, Vector2(0, sign(amount))):
			velocity.y = 0
			break
		move -= 1
		for block in blocks:
			block.global_position.y += sign(amount)


func get_type() -> Type:
	var has_wall = false
	var has_player = false
	
	for block in blocks:
		if block.type == Block.Type.WALL:
			has_wall = true
			break
		elif block.type == Block.Type.PLAYER:
			has_player = true
	
	if has_wall:
		return Type.WALL
	elif has_player:
		return Type.PLAYER
	else:
		return Type.SOLID


func merge(other: BlockGroup):
	for block in other.blocks:
		blocks.append(block)
