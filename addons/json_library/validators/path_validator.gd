class_name JPathValidator extends JStringValidator

enum {
	ANY,
	DIRECTORY,
	FILE
}

var type = ANY

var filter_extensions_enabled := false
var extensions: Array[String] = []
var should_exist := false


## Set the validator to check if the path is a file path (only useful for existing paths)
func file() -> JPathValidator:
	type = FILE
	return self


## Set the validator to check if the path is a directory path (only useful for existing paths)
func directory() -> JPathValidator:
	type = DIRECTORY
	filter_extensions_enabled = false
	return self


## Set the validator to check if the path is an image
func image() -> JPathValidator:
	return set_extensions([".png", ".jpg", ".jpeg", ".svg"])


## Set the validator to check if the path is a Godot resource
func resource() -> JPathValidator:
	return set_extensions([".res", ".tres"])


## Set the validator to check if the path is a 3D mesh
func mesh() -> JPathValidator:
	return set_extensions([".gltf", ".obj", ".fbx"])


## Set the validator to check for a given file extension
func add_extension(ext: String) -> JPathValidator:
	filter_extensions_enabled = true
	extensions.append(ext)
	return self


## Set the validator to check for any file extension in a given list
func set_extensions(exts: Array[String]) -> JPathValidator:
	filter_extensions_enabled = true
	extensions.append_array(exts)
	return self


## Sets the validator to check whether the file/directory exists
func set_should_exist(value: bool = true) -> JPathValidator:
	should_exist = value
	return self


func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not super.is_valid(data): return false
	if not data is String: return false
	var path := Json.Path.new(data)
	return (
		super.is_valid(data)
		and ((
			path.exists() if type == ANY
			else path.is_existing_file() if type == FILE
			else path.is_existing_directory()
		) if should_exist else true)
		and (path.has_any_extension(extensions) if filter_extensions_enabled else true)
	)


func cleaned_data(data, _default := "") -> String:
	return (data as String).simplify_path()
