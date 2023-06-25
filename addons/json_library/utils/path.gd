class_name JsonLibrary_Utils_Path extends Object


## Utility functions to handle file system paths

var _path: String


func _init(path: String) -> void:
	_path = path.simplify_path()


func join(path: String) -> String:
	return _path.path_join(path)


func extension() -> String:
	return (_path.rsplit(".", true, 1)[-1]).to_lower()


func has_extension(ext: String) -> bool:
	return extension() == ext.to_lower().replace(".", "")


func has_any_extension(exts: Array[String]) -> bool:
	return exts.any(has_extension)


func exists() -> bool:
	return is_existing_file() or is_existing_directory()


func is_existing_directory() -> bool:
	return DirAccess.dir_exists_absolute(_path)


func is_existing_file() -> bool:
	return FileAccess.file_exists(_path)


func directory() -> String:
	return _path.rsplit("/", true, 1)[0]
