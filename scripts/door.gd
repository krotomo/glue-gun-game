extends Area2D


@export var target_scene : PackedScene


func _input(event):
	if !target_scene:
		return
	if event.is_action_pressed("interact"):
		for area in get_overlapping_areas():
			if area.is_in_group("block"):
				if area.type == Block.Type.PLAYER:
					Game.switch_scene(target_scene)
