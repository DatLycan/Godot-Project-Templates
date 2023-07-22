class_name Scene

static func add(data: SceneData, parent: Node = App.loop) -> Node:
	var node: Node = data.scene.instantiate()
	node.set_meta("locked", data.locked)
	parent.add_child(node)
	return node

static func switch(data: SceneData) -> Node:
	if data.unload:
		for c in App.loop.get_children():
			if c.get_meta("locked") and not data.forced: continue
			c.queue_free()
	var node: Node = data.scene.instantiate()
	node.set_meta("locked", data.locked)
	App.loop.add_child(node)
	Event.scene_changed.emit()
	return node
