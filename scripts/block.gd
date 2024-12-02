class_name Block
extends Node2D

enum Type { WALL, SOLID, PLAYER }
@export var type : Type = Type.WALL
@export var texture : Texture2D
@export var texture_origin : Vector2i
@onready var sprite = $Sprite2D
@onready var left = $Left
@onready var right = $Right
@onready var up = $Up
@onready var down = $Down
@onready var id = Game.block_id()
const SIZE = 32


func _ready():
	sprite.texture = texture
	sprite.region_enabled = true
	sprite.region_rect = Rect2(texture_origin, Vector2(SIZE, SIZE))
