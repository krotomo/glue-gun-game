class_name BlockGroup
extends RefCounted

enum Type { PLAYER, SOLID, WALL }

var blocks = []
var type = Type.SOLID


func _calculate_type() -> Type:
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
	type = _calculate_type()
