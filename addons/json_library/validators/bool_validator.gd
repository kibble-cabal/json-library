class_name JBoolValidator extends JPropertyValidator

var _allow_truthy_falsey := false


func allow_truthy_falsey(value := true) -> JBoolValidator:
	_allow_truthy_falsey = value
	return self


func is_valid(data) -> bool:
	if data == null: return _is_nullable
	if not super.is_valid(data): return false
	if data is bool: return true
	elif _allow_truthy_falsey:
		if data is String: return data.to_lower() in ["true", "false"]
		elif data is int or data is float: return is_zero_approx(data) or is_equal_approx(data, 1)
		else: return false
	else: return false


func cleaned_data(data, default = false) -> bool:
	if data is bool: return data
	if data is String: return data.to_lower() == "true"
	if data is int or data is float: return not is_zero_approx(data)
	return default


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "boolean": 
		var validator := JBoolValidator.new()
		if "enum" in schema: validator.options(schema["enum"])
		return validator
	return null
