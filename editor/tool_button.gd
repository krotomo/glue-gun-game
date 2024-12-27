extends Button


enum Tool {
	PAINT,
	ERASE
}

@export var tool: Tool = Tool.PAINT