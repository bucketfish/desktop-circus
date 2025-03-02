extends Window

@onready var _Camera: Camera2D = $ViewCamera

@onready var main = get_node("/root/main")
var world_offset: = Vector2i.ZERO
var last_position: = Vector2i.ZERO
var velocity: = Vector2i.ZERO
var focused: = false

var parent_node: NodePath

func _ready() -> void:
	_Camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT

	transient = true # Make the window considered as a child of the main window
	close_requested.connect(queue_free) # Actually close the window when clicking the close button

func _process(delta: float) -> void:
	velocity = position - last_position
	last_position = position
	_Camera.position = get_camera_pos_from_window()

func get_camera_pos_from_window()->Vector2i:
	return (position + velocity - world_offset) / Vector2i(_Camera.zoom)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		main.clicked_from(self.parent_node)
	
	else:
		_unhandled_input(event)

func _unhandled_input(event):
	main._unhandled_input(event)
