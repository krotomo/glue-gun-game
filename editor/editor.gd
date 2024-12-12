extends VSplitContainer


@onready var add_layer_button = $HSplitContainer/LayerPanel/LayerPanelButtons/AddLayerButton
@onready var remove_layer_button = $HSplitContainer/LayerPanel/LayerPanelButtons/RemoveLayerButton
@onready var layer_list = $HSplitContainer/LayerPanel/LayerList
var layer_id = 0
var layer_button_group = ButtonGroup.new()
var selected_layer_id = -1

func _ready():
	add_layer_button.pressed.connect(add_layer)
	remove_layer_button.pressed.connect(remove_layer)


func add_layer():
	var id = layer_id
	layer_id += 1

	var button = Button.new()
	button.toggle_mode = true
	button.button_group = layer_button_group
	button.text = "Layer " + str(id)
	layer_list.add_child(button)


func remove_layer():
	for child in layer_list.get_children():
		if child is Button:
			if child.button_pressed:
				child.queue_free()
				break
