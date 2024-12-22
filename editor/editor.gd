extends VSplitContainer

const TileButton = preload("res://editor/tile_button.gd")

@export var tile_set: TileSet
@export var outline_texture: Texture2D
@onready var tile_container = $HSplitContainer/VBoxContainer/ScrollContainer/MarginContainer/TileContainer
@onready var subviewport_container = $HSplitContainer/SubViewportContainer
var button_group = ButtonGroup.new()


func _ready():
	for idx in range(tile_set.get_source_count()):
		var source_id = tile_set.get_source_id(idx)
		var source : TileSetAtlasSource = tile_set.get_source(source_id)
		var texture = source.texture
		var dimensions = source.get_atlas_grid_size()
		for row in range(dimensions.y):
			for col in range(dimensions.x):
				var atlas_texture = AtlasTexture.new()
				atlas_texture.atlas = texture
				atlas_texture.region = Rect2i(col * Block.SIZE, row * Block.SIZE, Block.SIZE, Block.SIZE)
	
				var button = TileButton.new()
				button.source_id = source_id
				button.atlas_coords = Vector2i(col, row)
				button.toggle_mode = true
				button.size = Vector2i(Block.SIZE, Block.SIZE)
				button.texture_normal = atlas_texture
				button.button_group = button_group
				
				var outline = TextureRect.new()
				outline.texture = outline_texture
				outline.visible = false
				outline.position = Vector2.ZERO
				outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
				button.add_child(outline)

				button.toggled.connect(func(pressed): outline.visible = pressed)

				tile_container.add_child(button)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos = subviewport_container.get_local_mouse_position()
		if local_pos.x < 0 or local_pos.y < 0 or local_pos.x > subviewport_container.size.x or local_pos.y > subviewport_container.size.y:
			return
		print(local_pos)
