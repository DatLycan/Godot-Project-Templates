extends Resource
class_name SceneData

@export var identifier: StringName = "NONE"

@export var scene: PackedScene
@export var locked: bool = false
@export var unload: bool = true
@export var forced: bool = false

func _init(_scene: PackedScene, _locked: bool = false, _unload: bool = true, _forced: bool = false) -> void:
	super._init()
	scene = _scene
	locked = _locked
	unload = _unload
	forced = _forced


static func new(_scene: PackedScene, _locked: bool = false, _unload: bool = true, _forced: bool = false) -> SceneData:
	return super.new()
