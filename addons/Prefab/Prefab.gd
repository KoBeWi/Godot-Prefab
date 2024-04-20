extends PackedScene
class_name Prefab

enum { FREE_MODE_INSTANT, FREE_MODE_DEFERRED, FREE_MODE_NONE }

static func create(node: Node, free_mode: int = FREE_MODE_INSTANT) -> Prefab:
	assert(node, "Invalid node provided.")
	
	var to_check := node.get_children()
	while not to_check.is_empty():
		var sub: Node = to_check.pop_back()
		if sub.owner == null:
			continue
		
		to_check.append_array(sub.get_children())
		
		if not node.owner or sub.owner == node.owner:
			sub.owner = node
	
	var prefab := Prefab.new()
	prefab.pack(node)
	
	match free_mode:
		FREE_MODE_INSTANT:
			node.free()
		FREE_MODE_DEFERRED:
			node.queue_free()
		FREE_MODE_NONE:
			pass
	
	return prefab
