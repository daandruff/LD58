extends Node2D

var direction : int = 1
var isBarking : float = 0
var hasStick : Node2D = null

@export var speed : int = 400
@export var barkDelay : int = 500
@export var pickupDistance : int = 100

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	var movementActive = false
	var bark = false
	
	print($AnimationPlayer.current_animation)
	
	if Input.is_action_pressed("left") and isBarking <= 0:
		position.x -= speed * delta
		direction = 1
		movementActive = true
	if Input.is_action_pressed("right") and isBarking <= 0:
		position.x += speed * delta
		direction = -1
		movementActive = true
	if Input.is_action_pressed("up") and isBarking <= 0:
		position.y -= (speed / 1.5) * delta
		movementActive = true
	if Input.is_action_pressed("down") and isBarking <= 0:
		position.y += (speed / 1.5) * delta
		movementActive = true
		
	if Input.is_action_just_pressed("interact") and isBarking <= 0:
		var stick = pickupStick()
		
		if (not stick and not hasStick):
			bark = true
			isBarking = barkDelay
		elif (stick and not hasStick):
			stick.pickup($Sprites/Snout/StickConnection)
			hasStick = stick
			$AnimationPlayer.speed_scale = 1.5
			$AnimationPlayer.play('stick')
		elif (hasStick):
			hasStick.drop(global_position)
			hasStick = null
			$AnimationPlayer.speed_scale = 1.5
			$AnimationPlayer.play('stick')
	
	if bark:
		$AnimationPlayer.speed_scale = 1.5
		$AnimationPlayer.play('bark')
	elif isBarking > 0:
		isBarking -= delta * 1000
	else:
		if movementActive:
			$AnimationPlayer.speed_scale = 2
			$AnimationPlayer.play('run')
		else:
			$AnimationPlayer.speed_scale = 1.5
			$AnimationPlayer.play('idle')
		
	scale.x = abs(scale.x) * direction


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
