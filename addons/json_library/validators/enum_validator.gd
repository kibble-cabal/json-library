class_name JEnumValidator extends JPropertyValidator

var _enum: Dictionary
var _ignore_case := false


func _init(enum_value: Dictionary = {}) -> void:
	_enum = enum_value


## Set the validator to be case insensitive
func ignore_case() -> JEnumValidator:
	_ignore_case = true
	return self


func is_valid(data) -> bool:
	if not data is String: return false
	if _ignore_case:
		for enum_key in _enum.keys():
			if enum_key.to_lower() == data.to_lower(): return true
		return false
	else: return data in _enum


func cleaned_data(data, default = 0) -> int:
	if _ignore_case:
		for enum_key in _enum.keys():
			if enum_key.to_lower() == data.to_lower(): return _enum[enum_key]
		return default
	else: return int(_enum[data]) if data in _enum else default
