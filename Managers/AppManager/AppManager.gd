extends Node

const StateDirectory = preload("res://addons/imjp94.yafsm/src/StateDirectory.gd")

@export var state: Node
@export_dir var scene_data_directory: String

@onready var loop: Node


func _ready() -> void:
	if get_tree().get_root().get_node_or_null("MainLoop"):
		state.start()

func get_scene_data(identifier: StringName) -> SceneData:
	var data: SceneData
	var files: PackedStringArray = DirAccess.open(scene_data_directory).get_files()
	for file in files:
		var path: String = "%s/%s" % [scene_data_directory, file]
		if FileAccess.file_exists(path):
			data = load(path)
			if data.identifier == identifier:
				return data
	assert(false, "SceneData: \"%s\" not found" % identifier)
	return data


func _on_state_pushed(to) -> void:
	var to_dir = StateDirectory.new(to)
	match to_dir.next():
		"Entry":
			pass
		"MainMenu":
			pass
		"Game":
			_on_nested_game_state_machine_pushed(to)
			pass
		"Exit":
			get_tree().quit()
		_:
			assert(false, "\"%s\" is not a valid state." % to)



func _on_nested_game_state_machine_pushed(to):
	var to_dir = StateDirectory.new(to)
	to_dir.goto(1)
	match to_dir.next():
		"Entry": # Game/Entry
			pass
		"Exit":
			state.clear_param()
		_:
			assert(false, "\"%s\" is not a valid state." % to)


