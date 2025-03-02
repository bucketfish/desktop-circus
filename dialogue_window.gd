extends Window

#@onready var _Camera: Camera2D = $ViewCamera
@onready var main = get_node("/root/main")


var dialogue_lines = {
	"moth": [
		["Oh... you caught me."],
		["Ugh, you caught me.", "I'll be back though... just you wait!"],
		["Stop touching me!", "I'm just chilling."],
		["You're so annoying."],
		["Fine, you got me.", "I'll be back."],
		["Are you not happy to see me?", ":("],
		["I love hanging around here! Do you not love me?"],
		["Okay, see you again, then, I guess."],
		["So forcefully removed..."],
		["I was just having fun in the circus!"]
	],
	"bee": [
		["How could you close my window?"],
		["I hunted day and night for those..."],
		["How dare you close my window!", "Sigh..."],
		["Those are very precious, you know.", "You always disappoint."],
		["And I thought this desktop was a safe place to store my favorites..."],
		["Do you not appreciate the efforts that I go through for you?", "Those took a long time to find!"],
		["Was it not funny? :("],
		["My dearest image...", "Gone, just like that."]
	]
}

var dialogue_images = {
	"moth": preload("res://dialogue_moth.png"),
	"bee": preload("res://dialogue_bee.png"),
	
}

var dialogue_colors = {
	"moth": "#ffffff",
	"bee": "#000000",
	"beetle": "#ffffff"
}

var cur_dialogue_name = ""
var cur_dialogue_series = 0
var cur_dialogue_count = 0


@onready var label = $Label

func _ready() -> void:
	#_Camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT

	transient = true # Make the window considered as a child of the main window
	close_requested.connect(window_close_requested) # Actually close the window when clicking the close button

	#mouse_passthrough_polygon = $Polygon2D.polygon
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func window_close_requested():
	pass
	
func set_image(image):
	$Image.texture = image
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		#main.clicked_from(self.parent_node)
		advance_dialogue()
	else:
		_unhandled_input(event)

func set_dialogue(name, count = -1, num = 0):
	if count == -1:
		count = randi_range(0, dialogue_lines[name].size() - 1)
		
	cur_dialogue_name = name
	cur_dialogue_series = count
	label.text = dialogue_lines[name][count][num]
	
	$Sprite2D.texture = dialogue_images[cur_dialogue_name]
	$Label.modulate = dialogue_colors[cur_dialogue_name]
	$Polygon2D.modulate = dialogue_colors[cur_dialogue_name]
	
func advance_dialogue():
	cur_dialogue_count += 1
	if cur_dialogue_count >= dialogue_lines[cur_dialogue_name][int(cur_dialogue_series)].size():
		queue_free()
	else:
		set_dialogue(cur_dialogue_name, cur_dialogue_series, cur_dialogue_count)
	
	
func _unhandled_input(event):
	main._unhandled_input(event)
