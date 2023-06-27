class_name JDictValidator extends JPropertyValidator

## Handles validation and cleanup of a [Dictionary] value
##
## This class handles validation of a [Dictionary]. 
## [br][br]This class differs from [JsonValidator] because  [JsonValidator] validates known properties, 
## while this class validates arbitrary properties – all keys are validated with one [JPropertyValidator] 
## and all values with another [JPropertyValidator].
## [br][br]This is like the [code]Record[/code] type in many languages such as Typescript.

## An [Array][[String]] list of all keys that must be present when validating a value
var required_keys: Array = []

## If provided, this validator will be used to validate all keys in the dictionary during [method is_valid].
## It will also be used during [method cleaned_data].
var key_validator: JPropertyValidator

## If provided, this validator will be used to validate all values in the dictionary during [method is_valid]
## It will also be used during [method cleaned_data].
var value_validator: JPropertyValidator


## Set [member key_validator] to the provided validator
func set_key_validator(validator: JPropertyValidator) -> JDictValidator:
	key_validator = validator
	return self


## Set [member value_validator] to the provided validator
func set_value_validator(validator: JPropertyValidator) -> JDictValidator:
	value_validator = validator
	return self


## Set [member required_keys] to the provided [Array][[String]] of keys
func set_required_keys(keys: Array) -> JDictValidator:
	required_keys = keys
	return self


## Returns [code]true[/code] if [code]data[/code] is a valid [Dictionary] based on the properties of this [JDictValidator] object.
## [br][b]Example:[/b]
## [codeblock]
## assert(JDictValidator.new()
##     .set_key_validator(JStringValidator.new())
##     .set_value_validator(JBoolValidator.new())
##     .is_valid({ hello_world = true })
## [/codeblock]
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


## Returns the provided [code]data[/code] with each key cleaned by the [member key_validator] (if it exists),
## and each value cleaned by the [member value_validator] (if it exists).
## If [code]data[/code] is not valid, returns [code]default[/code].
func cleaned_data(data, default = {}) -> Dictionary:
	if not is_valid(data): return default
	var cleaned := {}
	for key in data.keys():
		var cleaned_key = key_validator.cleaned_data(key) if key_validator else key
		var cleaned_value = value_validator.cleaned_data(data[key]) if value_validator else data[key]
		cleaned[cleaned_key] = cleaned_value
	return cleaned
