class_name Json extends Object

static var Editor: EditorInterface = null

## See ["addons/json_library/utils/math.gd"] and ["addons/json_library/utils/path.gd"]
const Utils := {
	Math = preload("utils/math.gd"),
	Path = preload("utils/path.gd")
}


static func get_plugin_directory() -> String:
	print(Json.Editor)
	if Json.Editor: return Json.Editor.get_current_directory()
	else: return "res://addons/json_library"
