class_name JVectorValidator extends JsonValidator

var type := TYPE_FLOAT

var has_min := false
var min = 0.0
var has_max := false
var max = 0.0
var has_step := false
var step = 0.0

var output := TYPE_DICTIONARY

var validator: JNumberValidator:
	set(value):
		validator = value
		if has_max: validator.set_maximum(max)
		if has_min: validator.set_minimum(min)
		if has_step: validator.set_step(step)


func is_float() -> JVectorValidator:
	type = TYPE_FLOAT
	validator = JFloatValidator.new()
	return self


func is_integer() -> JVectorValidator:
	type = TYPE_INT
	validator = JIntValidator.new()
	return self


func set_minimum(value: float) -> JVectorValidator:
	validator.set_minimum(value)
	return self


func set_maximum(value: float) -> JVectorValidator:
	validator.set_maximum(value)
	return self


func set_step(value: float) -> JVectorValidator:
	validator.set_step(value)
	return self


func vec2() -> JVectorValidator:
	output = TYPE_VECTOR2
	return is_float().add_property("x", validator).add_property("y", validator)


func vec2i() -> JVectorValidator:
	output = TYPE_VECTOR2I
	return is_integer().add_property("x", validator).add_property("y", validator)


func vec3() -> JVectorValidator:
	output = TYPE_VECTOR3
	return is_float().add_property("x", validator).add_property("y", validator).add_property("z", validator)


func vec3i() -> JVectorValidator:
	output = TYPE_VECTOR3I
	return is_integer().add_property("x", validator).add_property("y", validator).add_property("z", validator)


func vec4() -> JVectorValidator:
	output = TYPE_VECTOR4
	return (is_float()
		.add_property("x", validator)
		.add_property("y", validator)
		.add_property("z", validator)
		.add_property("w", validator))


func vec4i() -> JVectorValidator:
	output = TYPE_VECTOR4I
	return (is_integer()
		.add_property("x", validator)
		.add_property("y", validator)
		.add_property("z", validator)
		.add_property("w", validator))


## Sets validator to validate as a color
func color() -> JVectorValidator:
	output = TYPE_COLOR
	return (is_float()
		.set_additional_properties()
		.add_property("r", validator)
		.add_property("g", validator)
		.add_property("b", validator))


## Sets the validator to make all properties optional
func all_optional(is_optional_value := true) -> JVectorValidator:
	validator.set_is_optional(is_optional_value)
	return self


func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not data is Dictionary: return false
	set_case_sensitive(false)
	for name in validators: validators[name] = validator
	return super.is_valid(data)


func cleaned_data(data, default = {}):
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
