extends Area2D

signal hit

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var target = position

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $AnimatedSprite2D.animation != "death":
		var velocity = Vector2.ZERO # The player's movement vector.
		
		if Input.is_action_pressed("right"):
			velocity.x += 1
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		if Input.is_action_pressed("mouse_click"):
			target = get_global_mouse_position()
			velocity = position.direction_to(target) * speed

		
		
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.stop()
		
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			# See the note below about boolean assignment.
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$AnimatedSprite2D.animation = "down"
			$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body):
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	hide() # Player disappears after being hit.
	$CollisionShape2D.set_deferred("disabled", true)
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.animation = "walk"
	


