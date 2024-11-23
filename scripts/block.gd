class_name Block
extends Node2D

enum Type { PLAYER, SOLID, WALL }
@export var type : Type = Type.WALL
@onready var left = $Left
@onready var right = $Right
@onready var up = $Up
@onready var down = $Down
@onready var id = Game.block_id()
const SIZE = 32
var remainder : Vector2 = Vector2.ZERO


func _ready():
	left.create_connection.connect(on_create_connection)
	right.create_connection.connect(on_create_connection)
	up.create_connection.connect(on_create_connection)
	down.create_connection.connect(on_create_connection)
	left.delete_connection.connect(on_delete_connection)
	right.delete_connection.connect(on_delete_connection)
	up.delete_connection.connect(on_delete_connection)
	down.delete_connection.connect(on_delete_connection)


func on_create_connection(this_connector, other_connector):
	Game.reference_node.add_connection(this_connector, other_connector, this_connector.direction)


func on_delete_connection(this_connector):
	Game.reference_node.delete_connection(this_connector)
