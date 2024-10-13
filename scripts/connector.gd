class_name Connector
extends Area2D
signal disconnect

enum States { IDLE, READY, CONNECTED }
@export var state : States = States.IDLE
@export var sprite : AnimatedSprite2D


func _ready():
	sprite = $Sprite


func _process(_delta):
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
	disconnect.emit()
