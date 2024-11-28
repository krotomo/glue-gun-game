extends TileMapLayer


var block_scene : PackedScene = preload("res://scenes/block.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var tiles = get_used_cells()
	for tile in tiles:
		var block = block_scene.instantiate()
		print(block)
		block.global_position = local_to_map(tile)
		get_parent().add_child(block)

		var tile_data = get_cell_tile_data(tile)
		var texture_origin = tile_data.texture_origin
		var source : TileSetAtlasSource = tile_set.get_source(get_cell_source_id(tile))
		var texture = source.texture
		print(texture)

		print(block.sprite)
		block.sprite.texture = texture
		block.sprite.region_enabled = true
		block.sprite.region_rect = Rect2(
			texture_origin, Vector2(Game.BLOCK_SIZE, Game.BLOCK_SIZE))
		
		get_parent().add_blocks([block])
	queue_free()
