extends Window

@onready var _Camera: Camera2D = $ViewCamera
@onready var main = get_node("/root/main")

func _ready() -> void:
	_Camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT

	transient = true # Make the window considered as a child of the main window
	close_requested.connect(window_close_requested) # Actually close the window when clicking the close button


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func window_close_requested():
	main.show_dialogue_window("bee")
	self.queue_free()
	
func set_image(image):
	$Image.texture = image
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if "parent_node" in self:
			main.clicked_from(self.parent_node)
	else:
		_unhandled_input(event)

func _unhandled_input(event):
	main._unhandled_input(event)
