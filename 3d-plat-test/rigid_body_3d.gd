extends RigidBody3D
@onready var _animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@export var player:NodePath
@onready var target = get_node(player)

#var global_position = Vector3.ZERO
var SPEED = 7.0
const JUMP_VELOCITY = 12.5
var tip_dist = 1.0
var min_height = 1.0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var target_pos = target.global_transform.origin
	if target_pos.y < min_height:
		target_pos.y = min_height
		
	var move_dir = Vector3(target_pos.x - global_transform.origin.x, 0, target_pos.z - global_transform.origin.z)
	
	#var dir = (target.global_transform.origin - global_transform.origin)
	#if tip_dist < move_dir.length():
		#linear_velocity = move_dir.normalized() * SPEED
#
	#else:
		#linear_velocity = Vector3.ZERO
		
	var pos = global_transform.origin
	pos.y = max(pos.y, min_height)
	global_transform.origin = pos	
	
	if Input.is_action_pressed("ui_left"):
		_animated_sprite.play("run_l")
	if Input.is_action_pressed("ui_right"):
		_animated_sprite.play("run_r")
	
	
