extends Camera2D
@onready var cursor = $Cursor


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	cursor.global_position = get_global_mouse_position()
