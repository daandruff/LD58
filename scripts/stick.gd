extends Node2D

@export_enum('Twig', 'Twig B', 'Twig C', 'Fence') var type : String = 'Twig'

var handle : Node2D = null
var shadow : Sprite2D = null
var parent : Node2D = null

func _ready() -> void:
	setType(false)
	
func _process(delta: float) -> void:
	pass

func setType(newType) -> void:
	if newType: type = newType
	
	var allTypeHandles = get_children()
	
	for x in allTypeHandles:
		x.visible = false
		
	match type:
		'Twig':
			handle = $StickA
			shadow = $StickA/StickAShade
		'Twig B':
			handle = $StickB
			shadow = $StickB/StickBShade
		'Twig C':
			handle = $StickC
			shadow = $StickC/StickCShade
		'Fence':
			handle = $Fence
			shadow = $Fence/FenceShade
		_:
			pass
	
	handle.visible = true

func pickup(newParent) -> Node2D:
	parent = newParent
	visible = false
	return self

func drop(parentPosition) -> void:
	parent = null
	position = parentPosition
	rotation = 0
	visible = true

func setShadow(state) -> void:
	shadow.visible = state
