extends CharacterBody3D
@onready var _animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var m_jump = $M_Jump
@onready var m_r = $M_R
@onready var m_l = $M_L
@onready var swap_back = $Swap_Back
@onready var swap = $Swap

var SPEED = 7.0
const JUMP_VELOCITY = 12.5

var dir_flag = 2 #by default mario will face left
var flag = 0
var flag_3D = false
var flag_hold = false
var m_l_p := false
var was_on_floor = false
var mario3D_turn = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if flag_3D:
		const SPEED = 8
		const JUMP_VELOCITY = 5.2
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("ui_cancel") and is_on_floor() and flag_3D == false:
		#_physics_3D(delta)
		flag_3D = true
		swap.play()
		_animated_sprite.play("temp_3D")
		rotation_degrees.y += 90
		global_position += Vector3(0, 0, 15)
		mario3D_turn = true
		
	if Input.is_action_pressed("ui_focus_next") and is_on_floor() and flag_3D:
		flag_3D = false
		swap_back.play()
		_animated_sprite.play("temp_3D")
		rotation_degrees.y -= 90
		global_position -= Vector3(0, 0, 15)
		mario3D_turn = true


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = ""

	if not flag_3D:
		var input_dir = Input.get_vector("ui_left", "ui_right", "", "")
		direction = (transform.basis * Vector3(input_dir.y, 0, input_dir.x)).normalized()
	else:
		var input_dir = Input.get_vector("ui_down", "ui_up", "ui_left", "ui_right")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		
	if Input.is_action_just_pressed("ui_up") and is_on_floor:
		if flag_3D:
			_animated_sprite.play("run_b")
			m_l.play()
			dir_flag = 3 # forward 3 back 4
	#if Input.is_action_just_released("ui_left") and not is_on_floor():
		#if is_on_floor:
			#flag_hold = false
	if Input.is_action_just_pressed("ui_left") and is_on_floor():
		#flag_hold = true
		if not flag_3D:
			_animated_sprite.play("run_l")
			#m_r.stream_paused = true
			m_l.play()
			dir_flag = 1 # left 1 right 2
		#else:
			#_animated_sprite.play("run_b")
			#dir_flag = 3 # forward 3 back 4
		
	if Input.is_action_just_released("ui_left") and is_on_floor():
		_animated_sprite.play("default_l")
	if Input.is_action_pressed("ui_left") and is_on_floor():
		if not m_l_p:
			m_l.play()
			m_l_p = true
		_animated_sprite.play("run_l")
		dir_flag = 1
	
	if Input.is_action_just_released("ui_left"):
		m_l_p = false
		
	if Input.is_action_just_pressed("ui_right") and is_on_floor():
		flag_hold = true
		_animated_sprite.play("run_r")
		#m_l.stream_paused = true
		m_r.play()
		#m_r.stream_paused = false
		dir_flag = 2
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if dir_flag == 2:
			_animated_sprite.play("jump_r")
			m_jump.play()
			#if flag_hold == true and is_on_floor():
				#_animated_sprite.play("run_r")
				
		if dir_flag == 1:
			_animated_sprite.play("jump_l")
			m_jump.play()
			#if flag_hold == true and is_on_floor():
				#_animated_sprite.play("run_l")
		if dir_flag == 3:
			_animated_sprite.play("jump_b")
			m_jump.play()
		if dir_flag == 4:
			_animated_sprite.play("jump_r")
			m_jump.play()


	#if Input.is_action_just_pressed("ui_accept") and is_on_floor() and dir_flag == 1:
		
		
	if Input.is_action_just_released("ui_right") and is_on_floor():
		_animated_sprite.play("default_r")
		if Input.is_action_pressed("ui_right") and is_on_floor():
			_animated_sprite.play("run_r")
			dir_flag = 2

			m_r.play()

	if Input.is_action_just_pressed("ui_shift") and is_on_floor:
		SPEED = 15.0
		_animated_sprite.speed_scale = 1.75
	if Input.is_action_just_released("ui_shift"):
		SPEED = 7.0
		_animated_sprite.speed_scale = 1.0
		

	if Input.is_action_just_pressed("ui_down") and is_on_floor() and flag_3D:
		_animated_sprite.play("run_r")
		dir_flag = 4
		#m_l.stream_paused = true
		m_r.play()
		#m_r.stream_paused = false
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if not is_on_floor():
		if _animated_sprite.animation.begins_with("jump"):
			if _animated_sprite.frame == _animated_sprite.sprite_frames.get_frame_count(_animated_sprite.animation) - 2:
				_animated_sprite.pause()
		
	
	var j_land = not was_on_floor and is_on_floor()
	
	
	if j_land:
		if flag_3D:
			if Input.is_action_pressed("ui_left"):
				_animated_sprite.play("run_l")
			if Input.is_action_pressed("ui_right"):
				_animated_sprite.play("run_r")
			if Input.is_action_pressed("ui_up"):
				_animated_sprite.play("run_b")
			if Input.is_action_pressed("ui_down"):
				_animated_sprite.play("run_r")
			else:
				if dir_flag == 1:
					_animated_sprite.play("default_l")
				if dir_flag == 2:
					_animated_sprite.play("default_r")
		else:
			if Input.is_action_pressed("ui_left"):
				_animated_sprite.play("run_l")
			if Input.is_action_pressed("ui_right"):
				_animated_sprite.play("run_r")
			else:
				if dir_flag == 1:
					_animated_sprite.play("default_l")
				if dir_flag == 2:
					_animated_sprite.play("default_r")
	
	was_on_floor = is_on_floor()

	if mario3D_turn:
		velocity = Vector3.ZERO
		mario3D_turn = false
	
func _physics_3D(delta):
	
	flag_3D = true
	rotation.y += 8
	translate(Vector3(0, 0, 15))
	
	
	
	
	
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
		


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "", "")
	var direction = (transform.basis * Vector3(input_dir.y, 0, input_dir.x)).normalized()
	
	if Input.is_action_pressed("ui_left") and is_on_floor():
		_animated_sprite.play("run_l")
		dir_flag = 1 # left 1 right 2
		#m_r.stream_paused = true
		#m_l.play()
		#m_l.stream_paused = false
		
	#if Input.is_action_just_released("ui_left") and is_on_floor():
		#_animated_sprite.play("default_l")
	if Input.is_action_pressed("ui_left") and is_on_floor():
		_animated_sprite.play("run_l")
		dir_flag = 1

		#m_l.play()

		
	if Input.is_action_just_pressed("ui_right") and is_on_floor():
		_animated_sprite.play("run_r")
		dir_flag = 2

		m_r.play()

		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and dir_flag == 2:
		_animated_sprite.play("jump_r")
		m_jump.play()


	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and dir_flag == 1:
		_animated_sprite.play("jump_l")
		m_jump.play()
		
	if Input.is_action_just_released("ui_right") and is_on_floor():
		_animated_sprite.play("default_r")
		if Input.is_action_pressed("ui_right") and is_on_floor():
			_animated_sprite.play("run_r")
			dir_flag = 2
			#m_l.stream_paused = true
			m_r.play()
			#m_r.stream_paused = false
			#m_r.stream_paused = true
			#m_r.stream_paused = true
			#m_r.stream_paused = false
	else:
		_animated_sprite.play("run_r")


		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	
	
		
		
