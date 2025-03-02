extends Window

@onready var main = get_node("/root/main")

func _ready() -> void:

	#transient = true # Make the window considered as a child of the main window
	#close_requested.connect(window_close_requested) # Actually close the window when clicking the close button
	mouse_passthrough_polygon = $Polygon2D.polygon
	
	$GPUParticles2D.emitting = true


func _process(delta):
	if $GPUParticles2D.emitting == false:
		queue_free()
