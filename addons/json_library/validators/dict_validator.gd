class_name JDictValidator extends JPropertyValidator

var required_keys: Array = []
var key_validator: JPropertyValidator
var value_validator: JPropertyValidator


func set_key_validator(validator: JPropertyValidator) -> JDictValidator:
	key_validator = validator
	return self


func set_value_validator(validator: JPropertyValidator) -> JDictValidator:
	value_validator = validator
	return self


func set_required_keys(keys: Array) -> JDictValidator:
	required_keys = keys
	return self


func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not super.is_valid(data): return false
	if not data is Dictionary: return false
	
	# Check for all required keys
	if not required_keys.all(func(k): return k in data): return false
	
	# Validate all keys and values
	for data_key in data.keys():
		if key_validator and not key_validator.is_valid(data_key): return false
		if value_validator and not value_validator.is_valid(data[data_key]): return false	
		
	return super.is_valid(data)
