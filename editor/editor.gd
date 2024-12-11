extends VSplitContainer


@onready var add_layer_button = $HSplitContainer/LayerPanel/LayerPanelButtons/AddLayerButton
@onready var remove_layer_button = $HSplitContainer/LayerPanel/LayerPanelButtons/RemoveLayerButton
@onready var layer_list = $HSplitContainer/LayerPanel/LayerList


func _ready():
	add_layer_button.pressed.connect(add_layer)
	remove_layer_button.pressed.connect(remove_layer)


func add_layer():
	layer_list.add_item("Layer " + str(layer_list.get_item_count() + 1))


func remove_layer():
	layer_list.remove_item(layer_list.get_selected_id())
