extends VSplitContainer

@export var tile_set: TileSet
@onready var tile_container = $HSplitContainer/VBoxContainer/TileContainer


func _ready():
	for idx in range(tile_set.get_source_count()):
		var source_id = tile_set.get_source_id(idx)
		var source : TileSetAtlasSource = tile_set.get_source(source_id)
		var texture = source.texture
		var dimensions = source.get_atlas_grid_size()
		print(dimensions)
		for row in range(dimensions.y):
			for col in range(dimensions.x):
				var atlas_texture = AtlasTexture.new()
				atlas_texture.atlas = texture
				atlas_texture.region = Rect2i(col * Block.SIZE, row * Block.SIZE, Block.SIZE, Block.SIZE)
				var button = TextureButton.new()
				button.size = Vector2i(Block.SIZE, Block.SIZE)
				button.texture_normal = atlas_texture
				tile_container.add_child(button)