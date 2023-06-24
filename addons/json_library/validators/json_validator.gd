class_name JsonValidator extends JPropertyValidator

var _allow_extra_properties: bool = false
var _ignore_case: bool = false

# Dictionary[String, JPropertyValidator]
var _validators := {}


## Set the validator to be case-insensitive. This only affects top-level properties, sub-schemas will not be affected.
## [codeblock]
## assert(JsonValidator.new()
##     .ignore_case()
##     .add_property("a", JsonIntValidator.new())
##     .is_valid({ "A" = 1 }))
## [/codeblock]
func ignore_case() -> JsonValidator:
	_ignore_case = true
	return self


## Allows arbitrary additional properties to be present in the JSON when validating
func allow_extra_properties() -> JsonValidator:
	_allow_extra_properties = true
	return self


## Add a <property name, [JPropertyValidator]> pair. Must be called AFTER all other config functions (like [method ignore_case], [method allow_extra_properties], etc)
func add_property(name: String, validator: JPropertyValidator) -> JsonValidator:
	var prop_name := name.to_lower() if _ignore_case else name
	_validators[prop_name] = validator.property(prop_name)
	return self


func _is_extra_property(name: String) -> bool:
	return (name.to_lower() if _ignore_case else name) in _validators


func is_valid(data: Dictionary) -> bool:
	var validated_data := {}
	
	# Get case sensitive/insensitive data
	if _ignore_case: for name in data.keys(): validated_data[name.to_lower()] = data[name]
	else: validated_data = data.duplicate()
	
	return (
		# Check that all keys are present and valid
		_validators.keys().all(func(name): return (
			_validators[name].is_valid(validated_data[name]) if name in validated_data
			else _validators[name]._is_optional
		))
		# Check that no extra properties exist, if not allowed
		and validated_data.keys().all(func(name: String) -> bool: return (
			true if _allow_extra_properties else _is_extra_property(name)
		))
	)


func cleaned_data(data: Dictionary, default = {}) -> Dictionary:
	var cleaned := default.duplicate()
	for prop in data:
		var name: String = prop.to_lower() if ignore_case else prop
		var validator: JPropertyValidator = _validators[name]
		cleaned[name] = validator.cleaned_data(data[prop], default.get(prop))
	return cleaned
