extends Sprite2D

@onready var main = get_node("/root/main")

const SCREEN_BOUNDS = Vector2(1000, 650)

var velocity = Vector2()


const CHANGE_LENGTH = 50

var captured_mouse = false

var captured_mouse_time = 0
var released_mouse_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	var lin_v = randf_range(2, 4.5)
	var angle = deg_to_rad(randf_range(0, 360))
	velocity = Vector2(cos(angle), sin(angle)) * lin_v
	
	#velocity = Vector2(randf_range(-5, 5), randf_range(-5, 5))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !captured_mouse:
		released_mouse_time += delta

		var mouse_pos = (get_viewport().get_mouse_position() + Vector2(0, 500)) / 3
		
		if released_mouse_time > 1 and self.global_position.distance_to(mouse_pos) < 5:
			captured_mouse = true
		elif self.global_position.distance_to(mouse_pos) < 5:
			return
		
		self.velocity = 1.0 * self.global_position.direction_to(mouse_pos)
		self.global_position += self.velocity
		
	else:
		if captured_mouse_time == 0:
			var lin_v = randf_range(2, 4.5)
			var angle = deg_to_rad(randf_range(0, 360))
			velocity = Vector2(cos(angle), sin(angle)) * lin_v
			
			#main.show_dialogue_window("beetle")
			
		captured_mouse_time += delta
		if captured_mouse_time < 2:
			get_node("/root/main")._MainWindow.grab_focus()
			self.global_position += self.velocity
			self.global_position.x = clamp(self.global_position.x, 10, SCREEN_BOUNDS.x)
			self.global_position.y = clamp(self.global_position.y, 10, SCREEN_BOUNDS.y)
			get_node("/root/main").get_viewport().warp_mouse(self.global_position * 3 - Vector2(10, 500))
		else:
			captured_mouse = false 
			captured_mouse_time = 0
			released_mouse_time = 0
