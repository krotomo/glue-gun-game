class_name Connector
extends Area2D
signal create_connection(this, other)
signal delete_connection()

enum States { DISABLED, IDLE, READY, CONNECTED, LOCKED }
enum Direction { UP, DOWN, LEFT, RIGHT }
@export var state : States = States.IDLE
@export var direction : Direction = Direction.UP
@export var other : Connector = null
var sprite : AnimatedSprite2D


func _ready():
	sprite = $Sprite


func _process(_delta):
	if (state == States.READY):
		var areas = get_overlapping_areas()
		for area in areas:
			if area is Connector and (
				area.state == States.READY or
				area.state == States.IDLE
			):
				create_connection.emit(self, area)


	if state == States.CONNECTED:
		sprite.play("connected")
	else:
		sprite.play("ready")
	if state == States.IDLE:
		if self == Game.nearest_connector:
			sprite.modulate.a = 0.5
		else:
			sprite.modulate.a = 0
		
	else:
		sprite.modulate.a = 1


func disconnect_connector():
	delete_connection.emit(self)
