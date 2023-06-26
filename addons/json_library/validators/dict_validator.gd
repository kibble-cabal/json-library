class_name JDictValidator extends JPropertyValidator

var _required_keys: Array = []
var _key_validator: JPropertyValidator
var _value_validator: JPropertyValidator


func keys(validator: JPropertyValidator) -> JDictValidator:
	_key_validator = validator
	return self


func values(validator: JPropertyValidator) -> JDictValidator:
	_value_validator = validator
	return self


func required(keys: Array) -> JDictValidator:
	_required_keys = keys
	return self


func is_valid(data) -> bool:
	if data == null: return _is_nullable
	if not super.is_valid(data): return false
	if not data is Dictionary: return false
	
	# Check for all required keys
	if not _required_keys.all(func(k): return k in data): return false
	
	# Validate all keys and values
	for data_key in data.keys():
		if _key_validator and not _key_validator.is_valid(data_key): return false
		if _value_validator and not _value_validator.is_valid(data[data_key]): return false	
		
	return super.is_valid(data)
