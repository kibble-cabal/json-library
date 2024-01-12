class_name JVectorValidator extends JsonValidator

## Handles validation and cleanup for [Dictionary]s representing vectors ([String], [float] or [int] pairs)
##
## This class handles the validation and cleanup of the following types, represented as JSON [Dictionary]s:
## [br]• [Vector2]
## [br]• [Vector2i]
## [br]• [Vector3]
## [br]• [Vector3i]
## [br]• [Vector4]
## [br]• [Vector4i]
## [br]• [Color]

## See [enum JNumberValidator.INCLUSIVE]
const INCLUSIVE = JNumberValidator.INCLUSIVE

## See [enum JNumberValidator.EXCLUSIVE]
const EXCLUSIVE = JNumberValidator.EXCLUSIVE

## Determines whether the values in the [Dictionary] should be [float] or [int].
## Can be either [enum TYPE_FLOAT] or [enum TYPE_INT]
var type := TYPE_FLOAT

## If [code]true[/code], all child properties will be set to optional (see [member JPropertyValidator.is_optional])
var all_properties_optional := false

## Determines [member min_type] for the child properties' validator (see [member JNumberValidator.min_type])
var min_type := INCLUSIVE
## Determines [member has_min] for the child properties' validator (see [member JNumberValidator.has_min])
var has_min := false
## Determines [member min] for the child properties' validator (see [member JNumberValidator.min])
var min = 0.0

## Determines [member max_type] for the child properties' validator (see [member JNumberValidator.max_type])
var max_type := INCLUSIVE
## Determines [member has_max] for the child properties' validator (see [member JNumberValidator.has_max])
var has_max := false
## Determines [member max] for the child properties' validator (see [member JNumberValidator.max])
var max = 0.0

## Determines [member has_step] for the child properties' validator (see [member JNumberValidator.has_step])
var has_step := false
## Determines [member step] for the child properties' validator (see [member JNumberValidator.step])
var step = 0.0

## Defines what type the result of [method cleaned_data] should be. Can be one of:
## [br]• [enum TYPE_VECTOR2] (will output [Vector2])
## [br]• [enum TYPE_VECTOR2I] (will output [Vector2i])
## [br]• [enum TYPE_VECTOR3] (will output [Vector3])
## [br]• [enum TYPE_VECTOR3I] (will output [Vector3i])
## [br]• [enum TYPE_VECTOR4] (will output [Vector4])
## [br]• [enum TYPE_VECTOR4I] (will output [Vector4i])
## [br]• [enum TYPE_COLOR] (will output [Color])
## [br]• [enum TYPE_DICTIONARY] (will output [Dictionary])
var output := TYPE_DICTIONARY


func _init() -> void:
	set_case_sensitive(false)

## Returns the [JNumberValidator] for the child properties based on [member type], [member max], [member min], [member step], etc. 
func get_validator() -> JNumberValidator:
	var validator: JNumberValidator
	match type:
		TYPE_FLOAT: validator = JFloatValidator.new()
		TYPE_INT: validator = JIntValidator.new()
	validator.set_is_optional(all_properties_optional)
	if has_max: 
		validator.set_maximum(max)
		validator.max_type = max_type
	if has_min: 
		validator.set_minimum(min)
		validator.max_type = max_type
	if has_step: validator.set_step(step)
	return validator


## Set the validator to validate properties as [float]s
func is_float() -> JVectorValidator:
	type = TYPE_FLOAT
	return self


## Set the validator to validate properties as [int]s
func is_integer() -> JVectorValidator:
	type = TYPE_INT
	return self


## Set [member JNumberValidator.min] for the child properties
func set_minimum(value: float) -> JVectorValidator:
	min_type = INCLUSIVE
	has_min = true
	min = value
	return self


## Set [member JNumberValidator.min] for the child properties
func set_minimum_exclusive(value: float) -> JVectorValidator:
	min_type = EXCLUSIVE
	has_min = true
	min = value
	return self


## Set [member JNumberValidator.max] for the child properties
func set_maximum(value: float) -> JVectorValidator:
	max_type = INCLUSIVE
	has_max = true
	max = value
	return self


## Set [member JNumberValidator.max] for the child properties
func set_maximum_exclusive(value: float) -> JVectorValidator:
	max_type = EXCLUSIVE
	has_max = true
	max = value
	return self


## Set [member JNumberValidator.step] for the child properties
func set_step(value: float) -> JVectorValidator:
	has_step = true
	step = value
	return self


## Updates this validator to use default configuration for validating and outputting [Vector2]s in [method cleaned_data]
func vec2() -> JVectorValidator:
	output = TYPE_VECTOR2
	return is_float().add_property("x", null).add_property("y", null)


## Updates this validator to use default configuration for validating and outputting [Vector2i]s in [method cleaned_data]
func vec2i() -> JVectorValidator:
	output = TYPE_VECTOR2I
	return is_integer().add_property("x", null).add_property("y", null)


## Updates this validator to use default configuration for validating and outputting [Vector3]s in [method cleaned_data]
func vec3() -> JVectorValidator:
	output = TYPE_VECTOR3
	return is_float().add_property("x", null).add_property("y", null).add_property("z", null)


## Updates this validator to use default configuration for validating and outputting [Vector3i]s in [method cleaned_data]
func vec3i() -> JVectorValidator:
	output = TYPE_VECTOR3I
	return is_integer().add_property("x", null).add_property("y", null).add_property("z", null)


## Updates this validator to use default configuration for validating and outputting [Vector4]s in [method cleaned_data]
func vec4() -> JVectorValidator:
	output = TYPE_VECTOR4
	return (is_float()
		.add_property("x", null)
		.add_property("y", null)
		.add_property("z", null)
		.add_property("w", null))


## Updates this validator to use default configuration for validating and outputting [Vector4i]s in [method cleaned_data]
func vec4i() -> JVectorValidator:
	output = TYPE_VECTOR4I
	return (is_integer()
		.add_property("x", null)
		.add_property("y", null)
		.add_property("z", null)
		.add_property("w", null))


## Updates this validator to use default configuration for validating and outputting [Color]s in [method cleaned_data]
func color() -> JVectorValidator:
	output = TYPE_COLOR
	return (is_float()
		.set_additional_properties()
		.set_minimum(0.0)
		.set_maximum(1.0)
		.add_property("r", null)
		.add_property("g", null)
		.add_property("b", null))


## Sets the validator to make all properties optional
func all_optional(value := true) -> JVectorValidator:
	all_properties_optional = value
	return self


## Returns [code]true[/code] if the provided [code]data[/code] is a valid [Dictionary] based on the properties of this [JVectorValidator] object.
## [br][b]Example:[/b]
## [codeblock]
## assert(JVectorValidator.new().vec2().is_valid({ x = 1, y = 2 })
## [/codeblock]
func is_valid(data) -> bool:
	var validator := get_validator()
	if data == null: return is_nullable
	if not data is Dictionary: return false
	for name in validators: validators[name] = validator
	return super.is_valid(data)


## Cleans the [code]data[/code] with the validator returned from [method get_validator].
## Returns the type corresponding to [member output].
## If [code]data[/code] is not valid, returns [code]default[/code].
## [br][b]Example:[/b]
## [codeblock]
## assert(JVectorValidator.new().vec2().cleaned_data({ x = 1, y = 2 }) == Vector2(1, 2))
## assert(JVectorValidator.new().color().cleaned_data({ r = 0, g = 0, b = 0 }) == Color.BLACK)
## [/codeblock]
func cleaned_data(data, default = {}):
	var validator := get_validator()
	var cleaned := {}
	# Convert to case insensitive defaults
	if default: for default_key in default: 
		cleaned[default_key.to_lower()] = default[default_key]
	# Clean int/floats
	for data_key in data.keys():
		cleaned[data_key.to_lower()] = validator.cleaned_data(data[data_key], cleaned.get(data_key.to_lower(), 0.0))
	# Create output
	match output:
		TYPE_VECTOR2: return Vector2(cleaned.x, cleaned.y)
		TYPE_VECTOR2I: return Vector2i(cleaned.x, cleaned.y)
		TYPE_VECTOR3: return Vector3(cleaned.x, cleaned.y, cleaned.z)
		TYPE_VECTOR3I: return Vector3i(cleaned.x, cleaned.y, cleaned.z)
		TYPE_VECTOR4: return Vector4(cleaned.x, cleaned.y, cleaned.z, cleaned.w)
		TYPE_VECTOR4I: return Vector4i(cleaned.x, cleaned.y, cleaned.z, cleaned.w)
		TYPE_COLOR: return Color(cleaned.r, cleaned.g, cleaned.b, cleaned.get("a", 1.0))
		_: return data
