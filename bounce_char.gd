extends Sprite2D


const SCREEN_BOUNDS = Vector2(1000, 650)

var velocity = Vector2()


const CHANGE_LENGTH = 50

var time_since_horizontal_wall = 100
const HORIZONTAL_THRESHOLD = 0.8

# Called when the node enters the scene tree for the first time.
func _ready():
	var lin_v = randf_range(2, 4.5)
	var angle = deg_to_rad(randf_range(0, 360))
	velocity = Vector2(cos(angle), sin(angle)) * lin_v


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = (get_viewport().get_mouse_position() + Vector2(0, 500)) / 3

	var dist_to_mouse = self.position.distance_to(mouse_pos)
	var multiplier = 0.3 if dist_to_mouse < 50 else 1.0
	self.position.x += self.velocity.x * multiplier
	self.position.y += self.velocity.y * multiplier
	
	self.frame = 0
	time_since_horizontal_wall += delta
	
	if time_since_horizontal_wall < HORIZONTAL_THRESHOLD:
		self.frame = 1
		if self.velocity.x >= 0:
			self.flip_h = false
		else:
			self.flip_h = true
	else:
		self.flip_h = false
	
	if self.position.x >= SCREEN_BOUNDS.x - CHANGE_LENGTH or self.position.x <= CHANGE_LENGTH:
		self.frame = 3
	if self.position.y >= SCREEN_BOUNDS.y - CHANGE_LENGTH or self.position.y <= CHANGE_LENGTH:
		self.frame = 2
		
	
	if self.position.x >= SCREEN_BOUNDS.x and self.velocity.x >= 0:
		self.velocity.x = -self.velocity.x
		time_since_horizontal_wall = 0
	if self.position.x <= 30 and self.velocity.x <= 0:
		self.velocity.x = -self.velocity.x
		time_since_horizontal_wall = 0
	if self.position.y >= SCREEN_BOUNDS.y and self.velocity.y >= 0:
		self.velocity.y = -self.velocity.y
	if self.position.y <= 30 and self.velocity.y <= 0:
		self.velocity.y = -self.velocity.y
