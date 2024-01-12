class_name JPathValidator extends JStringValidator

## Handles validation and cleanup of [String] values represeting file system paths
##
## Because this is a Godot-specific feature, this type of validator can only be created through code, and
## not JSON schemas using the [method JPropertyValidator.from_schema] method.

enum {
	ANY, ## A path leading to a file or directory
	DIRECTORY, ## A path leading to a directory
	FILE ## A path leading to a file
}

## Defines whether this path should lead to a file, directory, or either
var type = ANY

## If [code]true[/code], a path must end with one of [member extensions] to be considered valid
var filter_extensions_enabled := false

## If [member filter_extensions_enabled] is [code]true[/code], the validator will check that the provided path ends with one of these [String]s
var extensions: Array[String] = []

## If [code]true[/code], the path should lead to an existing file or directory
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
	return file().set_extensions([".png", ".jpg", ".jpeg", ".svg"])


## Set the validator to check if the path is a Godot resource
func resource() -> JPathValidator:
	return file().set_extensions([".res", ".tres"])


## Set the validator to check if the path is a 3D mesh
func mesh() -> JPathValidator:
	return file().set_extensions([".gltf", ".obj", ".fbx"])


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


## Returns [code]true[/code] if the provided [code]data[/code] is a valid [String] path based on the properties of this [JStringValidator] object.
## [br][b]Example:[/b]
## [codeblock]
## assert(JStringValidator.new()
##     .image()
##     .is_valid("my_image.png"))
## [/codeblock]
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


## If [code]data[/code] is valid, returns a simplified path (see [method String.simplify_path]). Otherwise, returns [code]default[/code].
func cleaned_data(data, default = "") -> String:
	if not is_valid(data): return default
	if data is String: return data.simplify_path()
	return super.cleaned_data(data, default)
