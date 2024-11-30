extends TileMapLayer


var block_scene : PackedScene = preload("res://scenes/block.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var tiles = get_used_cells()
	for tile in tiles:
		var block : Block = block_scene.instantiate()
		block.global_position = to_global(map_to_local(tile))
		get_parent().call_deferred("add_child", block)

		var tile_data : TileData = get_cell_tile_data(tile)
		var source : TileSetAtlasSource = tile_set.get_source(get_cell_source_id(tile))
		var texture = source.texture
		var texture_origin = source.get_tile_texture_region(get_cell_atlas_coords(tile))
		block.texture = texture
		block.texture_origin = texture_origin.position
		block.type = tile_data.get_custom_data("type")

		var blocks : Array[Block] = [block]
		get_parent().call_deferred("add_blocks", blocks)
	queue_free()
