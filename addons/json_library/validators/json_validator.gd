class_name JsonValidator extends JPropertyValidator

## Handles validation and cleanup for JSON object values ([Dictionary]s)

## If [code]true[/code], valid data may include extra properties not accounted for in [member validators]
var additional_properties: bool = false

## If [code]true[/code], data keys must match exactly to the specified validator keys to be considered valid.
## [br][b]Example:[/b]
## [codeblock]
## assert(JsonValidator.new()
##     .add_property("X_VALUE", JsonIntValidator.new())
##     .add_property("Y_VALUE", JsonIntValidator.new())
##     .set_case_sensitive(false)
##     .is_valid({ x_value = 1, y_value = 2 }))
## [/codeblock]
var case_sensitive: bool = true

## [Dictionary][[String] keys, [JPropertyValidator] values] containing property namee [String]s and their associated [JPropertyValidator]s
var validators := {}


## An [Array][[String]] of the properties that a required in this validator.
## Do NOT mutate directly, this is just a getter. Properties are required by default so 
## this never needs to be mutated.
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
func set_additional_properties(value: bool = true) -> JsonValidator:
	additional_properties = value
	return self


## Add a [[String] property name, [JPropertyValidator] validator] pair
func add_property(name: String, validator: JPropertyValidator) -> JsonValidator:
	validators[name] = validator
	return self


## Returns [code]true[/code] if [code]property[/code] is an optional property
func is_property_optional(property: String) -> bool:
	if property in validators: return (validators[property] as JPropertyValidator).is_optional
	return true


func _has_key(dict: Dictionary, key: String) -> bool:
	return key in dict if case_sensitive else Json.Dict.has_key_case_insensitive(dict, key)


func _get_from_dict(dict: Dictionary, key: String, default = null):
	return dict.get(key, default) if case_sensitive else Json.Dict.get_case_insensitive(dict, key, default)


## Returns [code]true[/code] if the provided [code]data[/code] is valid.
## This takes into account all [member validators].
## [br][b]Example:[/b]
## [codeblock]
## assert(JsonValidator.new()
##     .add_property("x", JsonIntValidator.new())
##     .add_property("y", JsonIntValidator.new())
##     .set_additional_properties(true)
##     .is_valid({ x = 1, y = 2, z = 3 }))
## [/codeblock]
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


## Returns the provided [code]data[/code] with each property cleaned by the corresponding [JPropertyValidator] in [member validators].
## If [code]data[/code] is not valid, returns [code]default[/code].
func cleaned_data(data: Dictionary, default = {}):
	if not is_valid(data): return default
	var cleaned := default.duplicate()
	for prop in data:
		var validator: JPropertyValidator = _get_from_dict(validators, prop)
		cleaned[prop] = validator.cleaned_data(data[prop], _get_from_dict(default, prop))
	return cleaned


## Returns a new [JsonValidator] from a provided JSON schema [Dictionary].
## See the [url=https://json-schema.org/understanding-json-schema/reference/object.html]object JSON Schema documentation[/url] for more information
## about what type of input can be provided to the [code]schema[/code] parameter.
## [br][br][b]Note:[/b] Only the following Object JSON Schema features are implemented (see [method JPropertyValidator.from_schema] for JSON schema features that apply to all data types)
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/object.html#properties][code]properties[/code][/url] → [member validators]
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/object.html#additional-properties][code]additionalProperties[/code][/url] → [member additional_properties]
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
		if "additionalProperties" in schema: validator.set_additional_properties(schema["additionalProperties"])
		return validator
	return null
