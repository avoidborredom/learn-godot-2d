extends RigidBody2D

var target = linear_velocity
var screen_size
var margin = 0
var screen_left
var screen_right
var screen_top
var screen_bottom
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names() # This returns an Array containing all three animation names: ["walk", "swim", "fly"].
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	
	screen_size = get_viewport_rect().size
	screen_left = margin
	screen_right = screen_size.x - margin
	screen_top = margin
	screen_bottom = screen_size.y - margin
	
	await get_tree().create_timer(0.5).timeout
	$Voice.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	bounce_mob_back()
	# queue_free()

func bounce_mob_back():
	if position.x < 0 || position.x >= screen_right:
		linear_velocity.x *= -1
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
	if position.y < 0 || position.y >= screen_bottom:
		linear_velocity.y *= -1
		$AnimatedSprite2D.flip_v = !$AnimatedSprite2D.flip_v
	
		
		
