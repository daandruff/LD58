extends Node2D

var parent : Node2D = null

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if parent:
		position = parent.global_position
		position.y += 5
		rotation = parent.global_rotation

func pickup(newParent) -> Node2D:
	$StickA/StickAShade.visible = false
	parent = newParent
	$StickA.z_index = 1
	$StickA.z_as_relative = false
	return self

func drop(parentPosition) -> void:
	$StickA/StickAShade.visible = true
	parent = null
	$StickA.z_index = 0
	$StickA.z_as_relative = true
	position = position
	rotation = 0
