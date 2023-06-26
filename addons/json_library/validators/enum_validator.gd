class_name JEnumValidator extends JPropertyValidator

var _enum: Dictionary
var _has_allowed_options := false
var _allowed_options: Array[String] = []
var _ignore_case := false


func _init(enum_value: Dictionary = {}) -> void:
	_enum = enum_value


## Set the validator to be case insensitive
func ignore_case() -> JEnumValidator:
	_ignore_case = true
	return self


func allow_options(options: Array[String]) -> JEnumValidator:
	_has_allowed_options = true
	_allowed_options.append_array(options)
	return self


func is_valid(data) -> bool:
	if data == null: return _is_nullable
	if not data is String: return false
	if _ignore_case:
		var enum_keys := Json.List.map_to_lower(_enum.keys())
		if data.to_lower() in enum_keys:
			if _has_allowed_options: return data.to_lower() in Json.List.map_to_lower(_allowed_options)
			else: return true
		else: return false
	else: return data in _enum


func cleaned_data(data, default = 0) -> int:
	if _ignore_case:
		for enum_key in _enum.keys():
			if enum_key.to_lower() == data.to_lower(): return _enum[enum_key]
		return default
	else: return int(_enum[data]) if data in _enum else default
