extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_node("/root/world/player")

var movement_speed = 5


func _ready():
	call_deferred("get_target")
	
func get_target():
	if player.is_on_floor():
		nav_agent.target_position = player.global_transform.origin
	movement_speed *= 1.0001
	
func _physics_process(_delta):
	get_target()
	print(movement_speed)
	
	var current_position = global_position
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = next_position - current_position
	new_velocity = new_velocity.normalized() * movement_speed
	
	velocity = new_velocity
	move_and_slide()
