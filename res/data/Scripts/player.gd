extends CharacterBody2D


@export var speed : float = 2

var direction : Vector2 = Vector2(0,1)
var last_velocity : Vector2 = Vector2(0,1)
var timer = null
var is_doubble_click = false
var is_running = false
var max_velocity = 2.0
func _ready():
	#$EzDialogue.start_dialogue(dialogue_json, state)
	
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.25
	add_child(timer)
	timer.name = "DoubleClickTimer"
	

func _physics_process(delta):
		if (velocity == Vector2.ZERO):
					last_velocity = velocity
		if (Input.is_action_just_pressed("left") 
		or Input.is_action_just_pressed("right") 
		or Input.is_action_just_pressed("down")
		or Input.is_action_just_pressed("up")):
			
			if timer.is_stopped():
				is_doubble_click = false
				timer.start()
				last_velocity = Vector2.ZERO
				is_running = false
			else:
				is_doubble_click = true
				if (last_velocity == velocity):
					is_running = true
				
		direction = Input.get_vector("left", "right", "up", "down").round()
		if direction && !is_running:
			velocity = direction * speed
		elif direction && is_running:
			velocity = direction * speed * 2
		else:
			velocity =  Vector2.ZERO

			#Тут скорость по вертикали поправить
		if velocity.length_squared() >= max_velocity * max_velocity:
			velocity = velocity.limit_length(max_velocity).ceil()
		move_and_collide(velocity)

func _process(delta: float) -> void:
	match direction:
		Vector2(1,0): #view right
			$AnimatedSprite2D.animation = "walk_right"
			$AnimatedSprite2D.play("walk_right")
		Vector2(-1,0):#view left
			$AnimatedSprite2D.animation = "walk_left"
			$AnimatedSprite2D.play("walk_left")
		Vector2(0,1):#view down
			$AnimatedSprite2D.animation = "walk_down"
			$AnimatedSprite2D.play("walk_down")
		Vector2(0,-1):#view up
			$AnimatedSprite2D.animation = "walk_up"
			$AnimatedSprite2D.play("walk_up")
		Vector2(1,-1):#view right up
			$AnimatedSprite2D.animation = "walk_upright"
			$AnimatedSprite2D.play("walk_upright")
		Vector2(1, 1):#view right down
			$AnimatedSprite2D.animation = "walk_downright"
			$AnimatedSprite2D.play("walk_downright")
		Vector2(-1,-1):#view left up
			$AnimatedSprite2D.animation = "walk_upleft"
			$AnimatedSprite2D.play("walk_upleft")
		Vector2(-1,1):#view left down
			$AnimatedSprite2D.animation = "walk_downleft"
			$AnimatedSprite2D.play("walk_downleft")
