class_name Json extends Object

static var Editor: EditorInterface = null


## See [JsonLibrary_Utils_Math]
const Math := preload("utils/math.gd")

## See [JsonLibrary_Utils_Path]
const Path := preload("utils/path.gd")

## See [JsonLibrary_Utils_Dict]
const Dict := preload("utils/dict.gd")

## See [JsonLibrary_Utils_Array]
const List := preload("utils/array.gd")


static func get_plugin_directory() -> String:
	if Json.Editor: return Json.Editor.get_current_directory()
	else: return "res://addons/json_library"
