extends CharacterBody2D

enum STATE {IDLE, WALK, STUNNED, SLASH}

@onready var timer: Timer = $Timer
@onready var stun_timer: Timer = $stunTimer
@onready var attack_hitbox: Area2D = $attack_hitbox
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

const movement_speed = 100;

var knockback = Vector2.ZERO;

var active_state := STATE.IDLE;

func _physics_process(delta: float) -> void:
	
	if(not knockback.is_zero_approx()):
		velocity += knockback;
		knockback *= 0.5;
		velocity *= 0.8
		
	update_state();
	print(active_state)
		
	texture_progress_bar.value = (timer.time_left / timer.wait_time) * 100;
	
	move_and_slide()

func switch_state(new_state: STATE):
	match(new_state):
		STATE.IDLE:
			pass
		STATE.WALK:
			pass
		STATE.STUNNED:
			pass
	active_state = new_state;

func update_state():
	match(active_state):
		STATE.IDLE:
			var directionX := Input.get_axis("left", "right")
			var directionY := Input.get_axis("up", "down")
			
			if(directionX or directionY):
				velocity = Vector2(directionX, directionY) * movement_speed;
				switch_state(STATE.WALK);
				
			if(not attack_hitbox.active): attack_hitbox.position = Vector2(0, 0);
			
			if Input.is_action_just_pressed("leftClick"):
				slash();
			
			if Input.is_action_just_pressed("skill 1"):
				tryUseSkill(1);
			if Input.is_action_just_pressed("skill 2"):
				tryUseSkill(2);
			
		STATE.WALK:
			var directionX := Input.get_axis("left", "right")
			var directionY := Input.get_axis("up", "down")
			
			if(directionX or directionY):
				velocity = Vector2(directionX, directionY) * movement_speed;
			else:
				velocity = Vector2(0, 0); 
				switch_state(STATE.IDLE)
			
			if(not attack_hitbox.active): attack_hitbox.position = Vector2(0, 0);
			
			if Input.is_action_just_pressed("leftClick"):
				slash();
			
			if Input.is_action_just_pressed("skill 1"):
				tryUseSkill(1);
			if Input.is_action_just_pressed("skill 2"):
				tryUseSkill(2);
			
		STATE.STUNNED:
			pass

	
func tryUseSkill(skill: int):
	if(PlayerData.currentSkills.size() > 0):
		if(timer.is_stopped()):
			timer.start();
		else:
			var tween = create_tween();
			texture_progress_bar.tint_progress = Color(1.0, 0.0, 0.0);
			tween.tween_property(texture_progress_bar, "tint_progress", Color(1.0, 1.0, 1.0), 1.0);
		
	
func skill():
	attack_hitbox.active = true;
	attack_hitbox.position = Vector2.from_angle(attack_hitbox.get_angle_to(get_global_mouse_position())) * 16;


func slash():
	pass


func _on_timer_timeout() -> void:
	skill();
	


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Enemy")):
		PlayerData.health -= 1;
		
		switch_state(STATE.STUNNED);
		stun_timer.start();
		knockback = Vector2.from_angle(body.get_angle_to(position)) * 200;
		print(knockback);


func _on_stun_timer_timeout() -> void:
	switch_state(STATE.IDLE);
