class_name JsonValidator extends JPropertyValidator

var additional_properties: bool = false
var case_sensitive: bool = true

# Dictionary[String, JPropertyValidator]
var validators := {}


var required_properties: Array:
	get: return validators.keys().filter(func(key): return not validators[key].is_optional)


## Set the validator to be case-insensitive. This only affects top-level properties, sub-schemas will not be affected.
## [codeblock]
## assert(JsonValidator.new()
##     .set_case_sensitive()
##     .add_property("a", JsonIntValidator.new())
##     .is_valid({ "A" = 1 }))
## [/codeblock]
func set_case_sensitive(value: bool = false) -> JsonValidator:
	case_sensitive = value
	return self


## Allows arbitrary additional properties to be present in the JSON when validating
func set_additional_properties() -> JsonValidator:
	additional_properties = true
	return self


## Add a <property name, [JPropertyValidator]> pair
func add_property(name: String, validator: JPropertyValidator) -> JsonValidator:
	validators[name] = validator
	return self


func _has_key(dict: Dictionary, key: String) -> bool:
	return key in dict if case_sensitive else Json.Dict.has_key_case_insensitive(dict, key)


func _get_from_dict(dict: Dictionary, key: String, default = null):
	return dict.get(key, default) if case_sensitive else Json.Dict.get_case_insensitive(dict, key, default)


func is_property_optional(property: String) -> bool:
	return (validators[property] as JPropertyValidator).is_optional


func is_valid(data) -> bool:
	if not super.is_valid(data): return false
	if not data is Dictionary: return false
	
	return (
		# Check that all keys are present and valid
		validators.keys().all(func(key: String) -> bool:
			if _has_key(data, key): return validators[key].is_valid(_get_from_dict(data, key))
			else: return is_property_optional(key))
		
		# Check that no extra properties exist, if not allowed
		and data.keys().all(
			func(name: String) -> bool: return (
				true if additional_properties 
				else _has_key(validators, name)
			))
	)


func cleaned_data(data: Dictionary, default = {}):
	var cleaned := default.duplicate()
	for prop in data:
		var validator: JPropertyValidator = _get_from_dict(validators, prop)
		cleaned[prop] = validator.cleaned_data(data[prop], _get_from_dict(default, prop))
	return cleaned


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "object":
		var validator := JsonValidator.new().set_additional_properties()
		var required_properties: Array = schema.get("required", [])
		if "enum" in schema: validator.set_options(schema["enum"])
		if "properties" in schema:
			for property_name in schema["properties"].keys():
				validator.add_property(
					property_name, 
					JPropertyValidator
						.from_schema(schema["properties"][property_name])
						.set_is_optional(not property_name in required_properties)
				)
		return validator
	return null
