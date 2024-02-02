@uid("uid://2hdrihw7uean") # Generated automatically, do not modify.
extends CharacterBody3D

const SPEED = 2.0
const ACCEL = 0.2
const JUMP_VELOCITY = 4.5

@onready var cam : Camera3D = $camera
@onready var interact_ray : RayCast3D = $camera/interact_ray

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion:
		rotate(Vector3.UP, event.relative.x * -0.0004)
		print(cam.basis.get_euler().x)
		if cam.basis.get_euler().x > 1 && sign(event.relative.y) == 1 || cam.basis.get_euler().x < -1 && sign(event.relative.y) == -1 || cam.basis.get_euler().x < 1 && cam.basis.get_euler().x > -1:
			cam.rotate(Vector3.RIGHT, event.relative.y * -0.0004)
	
	if Input.is_action_just_pressed("action"):
		if interact_ray.is_colliding():
			print("hjere")
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var input_dir = Input.get_vector("left", "right", "forward", "back").normalized()
	input_dir.x /= 1.5
	
	if input_dir.y > 0:
		input_dir.y /= 2
	
	var direction = (transform.basis * Vector3(input_dir.x, velocity.y, input_dir.y))
	
	var aim = direction * SPEED
	if (aim - velocity).length() > ACCEL:
		velocity += (aim - velocity).normalized() * ACCEL
	else:
		velocity = aim
	
	move_and_slide()
