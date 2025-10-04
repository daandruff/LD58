extends CharacterBody2D

var direction : int = 1
var isBarking : float = 0
var hasStick : Node2D = null

@export var speed : int = 400
@export var barkDelay : int = 500
@export var pickupDistance : int = 75

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var movementActive = false
	velocity.x = 0
	velocity.y = 0
	
	if ($AnimationPlayer.current_animation == 'bark'): return
	if ($AnimationPlayer.current_animation == 'stick'): return
	
	if Input.is_action_pressed("left") and isBarking <= 0:
		velocity.x = -speed
		$Sprites.scale.x = 1
		direction = 1
		movementActive = true
	if Input.is_action_pressed("right") and isBarking <= 0:
		velocity.x = speed
		$Sprites.scale.x = -1
		direction = -1
		movementActive = true
	if Input.is_action_pressed("up") and isBarking <= 0:
		velocity.y = -(speed / 1.5)
		movementActive = true
	if Input.is_action_pressed("down") and isBarking <= 0:
		velocity.y = (speed / 1.5)
		movementActive = true
	
	if Input.is_action_just_pressed("interact") and isBarking <= 0:
		var stick = pickupStick()
		
		if (not stick and not hasStick):
			$AnimationPlayer.speed_scale = 1.5
			$AnimationPlayer.play('bark')
			$AnimationPlayer.queue("idle")
		elif (stick and not hasStick):
			$AnimationPlayer.speed_scale = 1.5
			$AnimationPlayer.play('stick')
			await get_tree().create_timer(.3).timeout
			stick.pickup($Sprites/Snout/StickConnection)
			hasStick = stick
		elif (hasStick):
			$AnimationPlayer.speed_scale = 1.5
			$AnimationPlayer.play('stick')
			await get_tree().create_timer(.3).timeout
			var dropPosition = Vector2(global_position.x + direction * -50, global_position.y)
			hasStick.drop(dropPosition)
			hasStick = null
	else:
		if movementActive:
			$AnimationPlayer.speed_scale = 2
			$AnimationPlayer.play('run')
		else:
			$AnimationPlayer.speed_scale = 1.5
			$AnimationPlayer.play('idle')
		
	move_and_slide()
	
func _process(delta: float) -> void:
	pass


func pickupStick():
	var allChildren = self.get_parent().get_children()
	var availableSticks = []
	
	for node in allChildren:
		if node.has_method('pickup'):
			if position.distance_to(node.position) < pickupDistance and not node.parent:
				availableSticks.append(node)
	
	availableSticks.sort_custom(sortByDistance)
	
	if (availableSticks.size() > 0):
		return availableSticks[0]
	else:
		return false
	
func sortByDistance(a, b) -> bool:
	return a.position.distance_to(position) < b.position.distance_to(position)
