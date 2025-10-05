extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var count = getCount()
	
	print("Count: ", count[0])
	print("Types: ", count[1])

func getCount() -> Array:
	var colliders = $Area2D.get_overlapping_areas()
	var allCountables = []
	var types = []
	
	for collider in colliders:
		var parent = collider.get_parent()
		if (parent.countable):
			allCountables.append(collider)
			if (not types.has(parent.countType)):
				types.append(parent.countType)
	
	return [allCountables.size(), types.size()]
