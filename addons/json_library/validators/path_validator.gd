class_name JPathValidator extends JStringValidator

enum {
	ANY,
	DIRECTORY,
	FILE
}

var _type = ANY

var _filter_extensions := false
var _extensions: Array[String] = []
var _should_exist := false


## Set the validator to check if the path is a file path (only useful for existing paths)
func file() -> JPathValidator:
	_type = FILE
	return self


## Set the validator to check if the path is a directory path (only useful for existing paths)
func directory() -> JPathValidator:
	_type = DIRECTORY
	_filter_extensions = false
	return self


## Set the validator to check if the path is an image
func image() -> JPathValidator:
	return extensions([".png", ".jpg", ".jpeg", ".svg"])


## Set the validator to check if the path is a Godot resource
func resource() -> JPathValidator:
	return extensions([".res", ".tres"])


## Set the validator to check if the path is a 3D mesh
func mesh() -> JPathValidator:
	return extensions([".gltf", ".obj", ".fbx"])


## Set the validator to check for a given file extension
func extension(ext: String) -> JPathValidator:
	_filter_extensions = true
	_extensions.append(ext)
	return self


## Set the validator to check for any file extension in a given list
func extensions(exts: Array[String]) -> JPathValidator:
	_filter_extensions = true
	_extensions.append_array(exts)
	return self


## Sets the validator to check whether the file/directory exists
func should_exist(value: bool = true) -> JPathValidator:
	_should_exist = value
	return self


func is_valid(data) -> bool:
	if data == null: return _is_nullable
	if not super.is_valid(data): return false
	if not data is String: return false
	var path := Json.Path.new(data)
	return (
		super.is_valid(data)
		and ((
			path.exists() if _type == ANY
			else path.is_existing_file() if _type == FILE
			else path.is_existing_directory()
		) if _should_exist else true)
		and (path.has_any_extension(_extensions) if _filter_extensions else true)
	)


func cleaned_data(data, _default := "") -> String:
	return (data as String).simplify_path()
