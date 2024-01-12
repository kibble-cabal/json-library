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


static func has_key_case_insensitive(dict: Dictionary, key) -> bool:
	var keys: Array = dict.keys().map(
		func(dict_key): return dict_key.to_lower() if dict_key is String else dict_key
	)
	if key is String: return key.to_lower() in keys
	return key in dict


static func get_case_insensitive(dict: Dictionary, key, default = null):
	for dict_key in dict.keys():
		if dict_key is String and key is String:
			if dict_key.to_lower() == key.to_lower(): return dict[dict_key]
		else: if dict_key == key: return dict[dict_key]
	return default


static func has_all_keys(dict: Dictionary, keys: Array = []) -> bool:
	return keys.all(func(key): return key in dict)


static func has_all_keys_case_insensitive(dict: Dictionary, keys: Array = []) -> bool:
	return keys.all(func(key): return Json.Dict.has_key_case_insensitive(dict, key))
