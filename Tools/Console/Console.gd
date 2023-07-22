extends CanvasLayer
class_name Console

@export var output: TextEdit
@export var input: TextEdit

@onready var App: Node = get_tree().root.get_node("/root/App")
@onready var Data: Data = get_tree().root.get_node("/root/Data")
@onready var Event: Event = get_tree().root.get_node("/root/Event")

var history: Array[String] = [""]
var method_names: Array[String] = []
var property_names: Array[String] = []

#############
#############
#############

func toggle_console():
	get_tree().paused = not get_tree().paused
	visible = not visible
	input.grab_focus()

func pause_mode():
	if not $Darken.visible:
		$Darken.visible = true
	else:
		$Darken.visible = false
	get_tree().paused = not get_tree().paused

func clear():
	output.text = ""

func quit():
	queue_free()

#############
#############
#############

func _ready():
	for method in get_method_list():
		var methodName: String = method["name"]
		method_names.append(methodName)

func _process(_delta):
	if input.get_line_count() > 1:
		input.clear()

func _input(event: InputEvent):
	if not input.has_focus():
		return
	if event is InputEventKey:
		input.request_code_completion()
		if event.keycode == KEY_UP and event.pressed:
			input.text = history[0]
		if event.keycode == KEY_ENTER and event.pressed:
			if event is InputEventWithModifiers and not event.shift_pressed:
				var expression = Expression.new()
				
				history.push_front(input.text)
				
				var parse_error = expression.parse(input.text)
				if parse_error != OK:
					output.text += "\n" + expression.get_error_text()
				var execute_result = expression.execute([], self)
				if expression.has_execute_failed():
					output.text += "\n" + expression.get_error_text()
				elif execute_result != null:
					output.text += "\n%s" % str(execute_result)
				elif input.text != "clear()":
					output.text += "\n%s" % input.text
				
				input.clear()

func _on_code_completion_requested():    
	for each in method_names:
		input.add_code_completion_option(CodeEdit.KIND_FUNCTION, each, each+"()", input.syntax_highlighter.function_color)
	for each in property_names:
		input.add_code_completion_option(CodeEdit.KIND_VARIABLE, each, each)
	input.update_code_completion_options(true)
