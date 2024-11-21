class_name BlockGroup
extends RefCounted


var blocks = []


func merge(other: BlockGroup):
	for block in other.blocks:
		blocks.append(block)
