class_name JsonLibrary_Utils_Dict extends Object

static func map(dict: Dictionary, mapping_function: Callable, recursive := false) -> Dictionary:
	var new_dict := {}
	for key in dict.keys():
		if dict[key] is Dictionary and recursive:
			new_dict[key] = JsonLibrary_Utils_Dict.map(dict[key], mapping_function, recursive)
		else: new_dict[key] = mapping_function.call(key, dict[key])
	return new_dict


static func map_keys(dict: Dictionary, mapping_function: Callable, recursive := false) -> Dictionary:
	var new_dict := {}
	for key in dict.keys():
		var new_key := mapping_function.call(key, dict[key])
		if dict[key] is Dictionary and recursive:
			new_dict[new_key] = JsonLibrary_Utils_Dict.map(dict[key], mapping_function, recursive)
		else: new_dict[new_key] = dict[key]
	return new_dict
