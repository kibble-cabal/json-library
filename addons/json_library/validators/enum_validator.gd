class_name JEnumValidator extends JPropertyValidator

var enum_dict: Dictionary
var has_allowed_options := false
var allowed_options: Array[String] = []
var case_sensitive := true


func _init(enum_value: Dictionary = {}) -> void:
	enum_dict = enum_value


## Set the validator to be case (in)sensitive
func set_case_sensitive(value: bool = true) -> JEnumValidator:
	case_sensitive = value
	return self


func allow_options(options: Array[String]) -> JEnumValidator:
	has_allowed_options = true
	allowed_options.append_array(options)
	return self


func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not data is String: return false
	if not case_sensitive:
		if Json.Dict.has_key_case_insensitive(enum_dict, data):
			if has_allowed_options: return data.to_lower() in Json.List.map_to_lower(allowed_options)
			else: return true
		else: return false
	else: 
		if has_allowed_options: return data in enum_dict and data in allowed_options
		else: return data in enum_dict


func cleaned_data(data, default = 0) -> int:
	if not case_sensitive: return Json.Dict.get_case_insensitive(enum_dict, data, default)
	else: return enum_dict.get(data, default)
