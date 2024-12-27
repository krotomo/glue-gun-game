extends VSplitContainer

const TileButton = preload("res://editor/tile_button.gd")
const ToolButton = preload("res://editor/tool_button.gd")

@export var tile_set: TileSet
@export var outline_texture: Texture2D
@onready var tile_container = $HSplitContainer/VBoxContainer/ScrollContainer/MarginContainer/TileContainer
@onready var subviewport_container = $HSplitContainer/SubViewportContainer
@onready var subviewport = $HSplitContainer/SubViewportContainer/SubViewport
@onready var camera = $HSplitContainer/SubViewportContainer/SubViewport/Camera2D
@onready var tile_map_layer = $HSplitContainer/SubViewportContainer/SubViewport/TileMapLayer
@onready var toolbar = $Toolbar
var tile_button_group = ButtonGroup.new()
var tool_button_group = ButtonGroup.new()


func _ready():
	for child in toolbar.get_children():
		if child is ToolButton:
			child.button_group = tool_button_group
			child.toggle_mode = true
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
				button.button_group = tile_button_group
				
				var outline = TextureRect.new()
				outline.texture = outline_texture
				outline.visible = false
				outline.position = Vector2.ZERO
				outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
				button.add_child(outline)

				button.toggled.connect(func(pressed): outline.visible = pressed)

				tile_container.add_child(button)


func _process(_delta):
	var tool_button : ToolButton = tool_button_group.get_pressed_button()
	if tool_button == null:
		return
	if Input.is_action_pressed("editor_action"):
		var tile_button : TileButton = tile_button_group.get_pressed_button()
		if tile_button == null:
			return
		var mouse_pos = subviewport_container.get_local_mouse_position()
		if mouse_pos.x < 0 or mouse_pos.y < 0 or mouse_pos.x > subviewport_container.size.x or mouse_pos.y > subviewport_container.size.y:
			return
		var world_pos = tile_map_layer.get_canvas_transform().affine_inverse() * mouse_pos
		var local_pos = tile_map_layer.to_local(world_pos)
		var tile_pos = tile_map_layer.local_to_map(local_pos)
		if tool_button.tool == ToolButton.Tool.PAINT:
			tile_map_layer.set_cell(tile_pos, tile_button.source_id, tile_button.atlas_coords, false)
		elif tool_button.tool == ToolButton.Tool.ERASE:
			tile_map_layer.set_cell(tile_pos, -1)
