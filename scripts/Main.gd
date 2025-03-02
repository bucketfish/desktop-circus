extends Node

@export var player_size: Vector2i = Vector2i(64, 64) # Should be the size of your character sprite, or slightly bigger
@export_range(0, 19) var player_visibility_layer: int = 0
@export_range(0, 19) var world_visibility_layer: int = 0
@export_node_path("Camera2D") var main_camera: NodePath
@export var view_window: PackedScene
@export var dialogue_window_scene: PackedScene
@export var confetti_window_scene: PackedScene

var world_offset: = Vector2i.ZERO

@onready var _MainCamera: Camera2D = get_node(main_camera)
@onready var _MainWindow: Window = get_window()
@onready var _MainScreen: int = _MainWindow.current_screen
@onready var _MainScreenRect: Rect2i = DisplayServer.screen_get_usable_rect(_MainScreen)

@onready var bounce_char_scene = preload("res://bounce_char.tscn")

var player_window: Window
var side_window: Window
var dialogue_window: Window
var confetti_window: Window

const IMAGES_COUNT = 7

var time_since_image = 0
var time_diff = 1

var time_since_confetti = 0
var confetti_cooldown = 2


@onready var images = [
	preload("res://images/0.png"),
	preload("res://images/1.png"),
	preload("res://images/2.png"),
	preload("res://images/3.png"),
	preload("res://images/4.png"),
	preload("res://images/5.png"),
	preload("res://images/6.png"),
]

func _ready():
	# ------------ MAIN WINDOW SETUP ------------
	# Enable per-pixel transparency, required for transparent windows but has a performance cost
	# Can also break on some systems
	ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed", true)
	
	

	_MainWindow.size = DisplayServer.screen_get_size()
	_MainWindow.position = Vector2(0, 500)
	
	prepare_window(_MainWindow, false)

	##DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
#
	
	for node in get_tree().get_nodes_in_group("WindowScene"):
		node.window = view_window.instantiate()
		node.window.parent_node = node.get_path()
		node.window.min_size = node.shape.size * Vector2(_MainCamera.zoom)
		node.window.size = node.shape.size * Vector2(_MainCamera.zoom) # * Vector2(1 / node.get_parent().scale.x, 1 / node.get_parent().scale.y)
		node.window.position = Vector2(node.global_position.x, node.global_position.y) + Vector2(-node.shape.size.x / 2, -node.shape.size.y / 2)

		prepare_window(node.window)
		

		add_child(node.window)


	_MainWindow.min_size = Vector2() # player_size * Vector2i(_MainCamera.zoom)
	_MainWindow.size = Vector2(50, 50) 
	_MainWindow.size = Vector2()


	player_window = view_window.instantiate()
	
	player_window.min_size = player_size * Vector2i(_MainCamera.zoom)
	player_window.size = player_size * Vector2i(_MainCamera.zoom)
	prepare_window(player_window)
	add_child(player_window)
	
	
	_MainWindow.visible = false
	_MainWindow.grab_focus()

func prepare_window(window, set_world = true):
	
	if set_world:
		window.world_2d = _MainWindow.world_2d
		#window.world_offset = world_offset


	# Set the window settings - most of them can be set in the project settings
	window.borderless = true		# Hide the edges of the window
	window.unresizable = true		# Prevent resizing the window
	window.gui_embed_subwindows = false # Make subwindows actual system windows <- VERY IMPORTANT
	# display->window->transparent has to be set to true in the project setting, in IDE´s Menu "Project->Project Settings...",
	# Otherwise _MainWindow.transparent doesn't affect the player´s sprite (tested in Godot 4.2.2)
	window.transparent = true		# Allow the window to be transparent
	# Settings that cannot be set in project settings
	window.transparent_bg = true	# Make the window's background transparent

	window.min_size = Vector2()
	window.set_canvas_cull_mask_bit(player_visibility_layer, true)

func _process(delta):

	time_since_image += delta 
	time_since_confetti += delta
	
	if time_since_image >= time_diff:
		var image_count = get_tree().get_nodes_in_group("ImageWindow").size()
		if not $ImageChar.is_open and image_count < 8:
			
			$ImageChar.load_image(images.pick_random())
			time_since_image -= time_diff
			time_diff = randi_range(15, 30)
			
		
		
	for node in get_tree().get_nodes_in_group("WindowScene"):
		node.window.position = (Vector2(node.global_position.x, node.global_position.y) + Vector2(-node.shape.size.x / 2, -node.shape.size.y / 2)) * Vector2(_MainCamera.zoom)
	
	

func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#
			#$ImageChar.load_image(images.pick_random())
		#

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if event.is_action_pressed("click"):
		pass
		
	if event is InputEventKey and event.pressed:
		print(OS.get_keycode_string(event.keycode))
		


func get_window_pos_from_camera()->Vector2i:
	return (Vector2i(_MainCamera.global_position + _MainCamera.offset) - player_size / 2) * Vector2i(_MainCamera.zoom) + world_offset

func create_view_window():
	var new_window: Window = view_window.instantiate()
	# Pass the main window's world to the new window
	# This is what makes it possible to show the same world in multiple windows
	new_window.world_2d = _MainWindow.world_2d
	new_window.world_3d = _MainWindow.world_3d
	# The new window needs to have the same world offset as the player
	new_window.world_offset = world_offset
	# Contrarily to the main window, hide the player and show the world
	new_window.set_canvas_cull_mask_bit(player_visibility_layer, true)
	new_window.set_canvas_cull_mask_bit(world_visibility_layer, true)
	add_child(new_window)
	side_window = new_window
	
	
func clicked_from(source: NodePath, show_bounce = false):
	print(source)
	var name = source.get_name(2)
	
	if !get_node(source):
		return
		
	if "parent_node" in get_node(source):
		printt(get_node(source).parent_node.get_name(2), "FGDFJGL")
		
	if name == "BounceChar":
		show_dialogue_window("moth")
		prints("show dialogue from ", source)
		
		if "window" in get_node(source).get_child(0):
			get_node(source).get_child(0).window.queue_free()
		if "window" in get_node(source):
			get_node(source).window.queue_free()
		if "parent_node" in get_node(source):
			get_node(get_node(source).parent_node).queue_free()
		if get_node(source).get_parent().is_in_group("BounceChar"):
			get_node(source).get_parent().queue_free()
		else:
			get_node(source).queue_free()
		
	if get_node(source).is_in_group("BounceChar"):
		show_dialogue_window("moth")
		prints("show dialogue by group from ", source)
		
		if "window" in get_node(source).get_child(0):
			get_node(source).get_child(0).window.queue_free()
		if "window" in get_node(source):
			get_node(source).window.queue_free()
		if "parent_node" in get_node(source):
			get_node(get_node(source).parent_node).queue_free()
		if get_node(source).get_parent().is_in_group("BounceChar"):
			get_node(source).get_parent().queue_free()
		else:
			get_node(source).queue_free()
	
		
	if name == "Circus":
		if time_since_confetti < confetti_cooldown:
			return
		time_since_confetti = 0
		$Circus/AnimationPlayer.play("shake")
		
		confetti_window = confetti_window_scene.instantiate()
	
		confetti_window.size = DisplayServer.screen_get_size()
		#player_window.size = player_size * Vector2i(_MainCamera.zoom)
		prepare_window(confetti_window, false)
		
		_MainWindow.visible = false
		add_child(confetti_window)
		
		var node: Sprite2D = bounce_char_scene.instantiate()
		node.get_child(0).window = view_window.instantiate()
		

		#node.get_child(0).window = image_window.instantiate()
		
		node.get_child(0).window.min_size = node.get_child(0).shape.size * Vector2(_MainCamera.zoom)
		node.get_child(0).window.size = node.get_child(0).shape.size * Vector2(_MainCamera.zoom) # * Vector2(1 / node.get_parent().scale.x, 1 / node.get_parent().scale.y)
		
		
		#node.get_child(0).window.min_size = node.get_child(0).shape.size * Vector2(_MainCamera.zoom)
		#node.get_child(0).window.size = node.get_child(0).shape.size * Vector2(_MainCamera.zoom)
		
		prepare_window(node.get_child(0).window)
		add_child(node)
		node.get_child(0).window.parent_node = node.get_child(0).get_path()
		node.get_child(0).window.position = Vector2(node.get_child(0).global_position.x, node.get_child(0).global_position.y) + Vector2(-node.get_child(0).shape.size.x / 2, -node.get_child(0).shape.size.y / 2)
		node.get_child(0).window.parent_node = node.get_path()
		add_child(node.get_child(0).window)


	
	
func show_dialogue_window(line_name):
	if dialogue_window != null:
		return
	dialogue_window = dialogue_window_scene.instantiate()
	dialogue_window.position = Vector2(1512 - dialogue_window.size.x / 2, 800)
	prepare_window(dialogue_window, false)
	
	add_child(dialogue_window)
	dialogue_window.set_dialogue(line_name)
	
	
func hide_dialogue_window():
	dialogue_window.queue_free()
