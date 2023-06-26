class_name JTestRunner extends VBoxContainer

@export var test_set_name: String = ""

var tests: Array[JTestCase] = []


func _ready() -> void:
	render_name()
	tests.map(run_test)


func render_name() -> void:
	var label := make_label("[b][color=white]{0}[/color][/b]".format([test_set_name]))
	var stylebox := StyleBoxFlat.new()
	stylebox.draw_center = false
	stylebox.border_width_bottom = 1
	stylebox.border_color = Color(Color.WHITE, 0.25)
	label.add_theme_stylebox_override("normal", stylebox)
	add_child(label)


func run_test(test: JTestCase) -> void:
	var test_results: Dictionary = test.get_test_results()
	add_child(make_label(
		test_results.report
			.replace("=green", "=MEDIUM_SEA_GREEN")
			.replace("=red", "=TOMATO")
	))
	if not test_results.is_ok:
		add_child(make_label("[color=TOMATO]{error_report}[/color]".format(test_results)))


func make_label(text: String = "") -> RichTextLabel:
	var label := RichTextLabel.new()
	label.fit_content = true
	label.bbcode_enabled = true
	label.text = text
	return label
