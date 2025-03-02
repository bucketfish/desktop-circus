extends Sprite2D


@export var image_window: PackedScene

const SCREEN_BOUNDS = Vector2(1000, 650)

var window: Window = null

var is_open = false
var finished_moving = false

var time_passed = 0

const DIFFERENCE_x = 490

var on_left = true

var middle_limit =200
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_image(image):
	time_passed = 0
	is_open = false
	finished_moving = false
	
	get_child(0).window.size.y = 125 * 3
	

	
	is_open = true
	window = image_window.instantiate()
	window.add_to_group("ImageWindow")
	window.set_image(image)
	
	on_left = randi_range(0, 1) == 0
	
	middle_limit = randf_range(150, 300)
	
	var pos_y = randf_range(100, 500)
	
	if on_left:
		self.position = Vector2(-10, pos_y)
	else:
		self.position = Vector2(SCREEN_BOUNDS.x + 10, pos_y)
	
	
	window.position = self.position + Vector2(-DIFFERENCE_x if on_left else SCREEN_BOUNDS.x + DIFFERENCE_x, 600)
	
	get_parent().add_child(window)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_open:
		return
	if !finished_moving:
		if on_left:
			
			self.position.x += 2
			window.position.x += 6
			
			if self.position.x >= middle_limit:
				finished_moving = true
		else:
			self.position.x -= 2
			window.position.x -= 6
			
			if self.position.x <= SCREEN_BOUNDS.x - middle_limit:
				finished_moving = true
	if finished_moving:
		time_passed += delta
		if time_passed > 0.3:
			time_passed -= 0.3

			self.flip_h = !self.flip_h
			
		
		if self.position.y >= 64:
			self.position.y -= 2
		else:
			get_child(0).window.size.y -= 2
			self.position.y -= 2
			
		if self.position.y <= -60:
			is_open = false
		
	
