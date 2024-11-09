class_name Block
extends Node2D
signal create_connection(this_area, other_area)
signal delete_connection(connector)

enum Type { PLAYER, SOLID, WALL }
@export var type : Type = Type.WALL
@onready var left = $Left
@onready var right = $Right
@onready var top = $Top
@onready var bottom = $Bottom
@onready var id = Game.block_id()


func _ready():
	left.create_connection.connect(on_create_connection)
	right.create_connection.connect(on_create_connection)
	top.create_connection.connect(on_create_connection)
	bottom.create_connection.connect(on_create_connection)
	left.delete_connection.connect(on_delete_connection)
	right.delete_connection.connect(on_delete_connection)
	top.delete_connection.connect(on_delete_connection)
	bottom.delete_connection.connect(on_delete_connection)


func on_create_connection(this_connector, other_connector):
	create_connection.emit(this_connector, other_connector)


func on_delete_connection(this_connector):
	delete_connection.emit(this_connector)
