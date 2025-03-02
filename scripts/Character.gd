extends CharacterBody2D

# From A Key(s) Path
# Movement exports
@export_group("Movement")
@export var max_speed:		float = 120.0 # Player max speed in px/s
@export var jump_height:	float = 40.0 # px
@export var gravity:		float = 310.0 # px/s/s
@export var gravity_strong:	float = 650.0 # px/s/s
@export var acceleration:	float = 512.0 # px/s/s
@export var deceleration:	float = 1024.0 # px/s/s
# Buffers
@export_group("Buffers")
@export var air_buffer = 0.1
@export var jump_buffer = 0.07

@onready var _Sprite = $Sprite
@onready var _Collision = $Collider

# Provided values
var dir: float = 0.0
var jump: bool = false

var target_speed: float = 0.0
var target_accel: float = 0.0
var target_gravity: float = gravity_strong
var air_time = air_buffer
var jump_time = jump_buffer
var on_ground: bool = false

func _process(_delta):
	return
	if target_speed < 0.0:
		_Sprite.flip_h = true
	elif target_speed > 0.0:
		_Sprite.flip_h = false

func _physics_process(delta):
	velocity.x = 100
	move_and_slide()
	return
	# Get horizontal movement direction
	# Direction is provided by a Movement Provider -> either a Player or IA
