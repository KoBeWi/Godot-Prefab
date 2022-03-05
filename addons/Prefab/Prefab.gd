extends PackedScene
class_name Prefab

static func create(node: Node, deferred_free := false) -> Prefab:
	assert(node, "Invalid node provided.")
	
	var to_check := node.get_children()
	while not to_check.empty():
		var sub: Node = to_check.pop_back()
		if sub.owner == null:
			continue
		
		to_check.append_array(sub.get_children())
		sub.owner = node
	
	var prefab: Prefab = load("res://addons/Prefab/Prefab.gd").new()
	prefab.pack(node)
	
	if deferred_free:
		node.queue_free()
	else:
		node.free()
	
	return prefab
	