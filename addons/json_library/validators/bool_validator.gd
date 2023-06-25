class_name JBoolValidator extends JPropertyValidator


func is_valid(data) -> bool:
	if data == null: return _is_nullable
	if data is bool: return true
	elif data is String: return data.to_lower() in ["true", "false"]
	elif data is int or data is float: return is_zero_approx(data) or is_equal_approx(data, 1)
	else: return false


func cleaned_data(data, default = false) -> bool:
	if data is bool: return data
	if data is String: return data.to_lower() == "true"
	if data is int or data is float: return not is_zero_approx(data)
	return default
