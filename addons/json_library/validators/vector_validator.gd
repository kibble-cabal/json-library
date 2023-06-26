class_name JVectorValidator extends JsonValidator

const INCLUSIVE = JNumberValidator.INCLUSIVE
const EXCLUSIVE = JNumberValidator.EXCLUSIVE

var type := TYPE_FLOAT
var all_properties_optional := false

var min_type := INCLUSIVE
var has_min := false
var min = 0.0

var max_type := INCLUSIVE
var has_max := false
var max = 0.0

var has_step := false
var step = 0.0

var output := TYPE_DICTIONARY


func _init() -> void:
	set_case_sensitive(false)


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


func is_float() -> JVectorValidator:
	type = TYPE_FLOAT
	return self


func is_integer() -> JVectorValidator:
	type = TYPE_INT
	return self


func set_minimum(value: float) -> JVectorValidator:
	min_type = INCLUSIVE
	has_min = true
	min = value
	return self


func set_minimum_exclusive(value: float) -> JVectorValidator:
	min_type = EXCLUSIVE
	has_min = true
	min = value
	return self


func set_maximum(value: float) -> JVectorValidator:
	max_type = INCLUSIVE
	has_max = true
	max = value
	return self


func set_maximum_exclusive(value: float) -> JVectorValidator:
	max_type = EXCLUSIVE
	has_max = true
	max = value
	return self


func set_step(value: float) -> JVectorValidator:
	has_step = true
	step = value
	return self


func vec2() -> JVectorValidator:
	output = TYPE_VECTOR2
	return is_float().add_property("x", null).add_property("y", null)


func vec2i() -> JVectorValidator:
	output = TYPE_VECTOR2I
	return is_integer().add_property("x", null).add_property("y", null)


func vec3() -> JVectorValidator:
	output = TYPE_VECTOR3
	return is_float().add_property("x", null).add_property("y", null).add_property("z", null)


func vec3i() -> JVectorValidator:
	output = TYPE_VECTOR3I
	return is_integer().add_property("x", null).add_property("y", null).add_property("z", null)


func vec4() -> JVectorValidator:
	output = TYPE_VECTOR4
	return (is_float()
		.add_property("x", null)
		.add_property("y", null)
		.add_property("z", null)
		.add_property("w", null))


func vec4i() -> JVectorValidator:
	output = TYPE_VECTOR4I
	return (is_integer()
		.add_property("x", null)
		.add_property("y", null)
		.add_property("z", null)
		.add_property("w", null))


## Sets null to validate as a color
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


func is_valid(data) -> bool:
	var validator := get_validator()
	if data == null: return is_nullable
	if not data is Dictionary: return false
	for name in validators: validators[name] = validator
	return super.is_valid(data)


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
