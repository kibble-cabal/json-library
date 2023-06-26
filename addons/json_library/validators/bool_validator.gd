class_name JBoolValidator extends JPropertyValidator

var allow_truthy_falsy := false


func set_allow_truthy_falsy(value := true) -> JBoolValidator:
	allow_truthy_falsy = value
	return self


func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not super.is_valid(data): return false
	if data is bool: return true
	elif allow_truthy_falsy:
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
		if "enum" in schema: validator.set_options(schema["enum"])
		return validator
	return null
