extends CharacterBody3D

@onready var neck = $neck
@onready var head = $neck/Head
@onready var standing_collision_shape_3d = $Standing_Collision_Shape3D
@onready var crouching_collision_shape_3d = $Crouching_Collision_Shape3D
@onready var ray_cast_3d = $RayCast3D
@onready var camera_3d = $neck/Head/Camera3D

var current_speed = 5.0
var lerp_speed  = 10.0
var direction = Vector3.ZERO
var crouching_depth = -0.5
var slide_timer = 0.0
var slide_timer_max = 1.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const walking_speed = 10.0
const sprinting_speed = 25.0
const crouching_speed = 5.0
const jump_velocity = 4.5
const mouse_sens = 0.4

var walking = false
var crouching = false
var sprinting = false
var free_looking = false
var sliding = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		if free_looking:
			
			neck.rotate_y(-deg_to_rad(event.relative.x * mouse_sens))
		else:
			
			neck.rotation.y = 0;
			rotate_y(-deg_to_rad(event.relative.x * mouse_sens))
		
		head.rotate_x(-deg_to_rad(event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))

func _physics_process(delta):
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	if Input.is_action_pressed("crouch"):
		current_speed = crouching_speed
		head.position.y = lerp(head.position.y, crouching_depth,delta*lerp_speed)
		
		
		standing_collision_shape_3d.disabled = true
		crouching_collision_shape_3d.disabled = false
		
		walking = false
		crouching = true
		sprinting = false
		
	elif !ray_cast_3d.is_colliding():
		standing_collision_shape_3d.disabled = false
		crouching_collision_shape_3d.disabled = true
		head.position.y = lerp(head.position.y,0.0,delta*lerp_speed)
		if Input.is_action_just_pressed("sprint"):
			current_speed = sprinting_speed
			
			walking = false
			crouching = false
			sprinting = true
			
		else:
			current_speed = walking_speed
			
			walking = true
			crouching = false
			sprinting = false
	
	# Handle free looking
	if Input.is_action_pressed("free_look"):
		free_looking = true
	else:
		free_looking = false
	
	if Input.is_action_just_pressed("sliding"):
		print("hello")
		sliding = true
		slide_timer = slide_timer_max
		print("Slide Begin");
	
	if sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			sliding = false
			print("Slide end");
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
