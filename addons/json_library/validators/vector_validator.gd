class_name JVectorValidator extends JsonValidator

var _type := TYPE_FLOAT

var _has_min := false
var _min = 0.0
var _has_max := false
var _max = 0.0
var _has_step := false
var _step = 0.0

var _output := TYPE_DICTIONARY

var _validator: JNumberValidator:
	set(value):
		_validator = value
		if _has_max: _validator.maximum(_max)
		if _has_min: _validator.minimum(_min)
		if _has_step: _validator.step(_step)


func is_float() -> JVectorValidator:
	_type = TYPE_FLOAT
	_validator = JFloatValidator.new()
	return self


func is_integer() -> JVectorValidator:
	_type = TYPE_INT
	_validator = JIntValidator.new()
	return self


func minimum(value: float) -> JVectorValidator:
	_validator.minimum(value)
	return self


func maximum(value: float) -> JVectorValidator:
	_validator.maximum(value)
	return self


func step(value: float) -> JVectorValidator:
	_validator.step(value)
	return self


func vec2() -> JVectorValidator:
	_output = TYPE_VECTOR2
	return is_float().add_property("x", _validator).add_property("y", _validator)


func vec2i() -> JVectorValidator:
	_output = TYPE_VECTOR2I
	return is_integer().add_property("x", _validator).add_property("y", _validator)


func vec3() -> JVectorValidator:
	_output = TYPE_VECTOR3
	return is_float().add_property("x", _validator).add_property("y", _validator).add_property("z", _validator)


func vec3i() -> JVectorValidator:
	_output = TYPE_VECTOR3I
	return is_integer().add_property("x", _validator).add_property("y", _validator).add_property("z", _validator)


## Sets validator to validate as a color
func color() -> JVectorValidator:
	_output = TYPE_COLOR
	return is_float().allow_extra_properties().add_property("x", _validator).add_property("y", _validator).add_property("z", _validator)


## Sets the validator to make all properties optional
func all_optional(is_optional_value := true) -> JVectorValidator:
	_validator.is_optional(is_optional_value)
	return self


func is_valid(data) -> bool:
	if not data is Dictionary: return false
	ignore_case()
	for name in _validators: _validators[name] = _validator
	return super.is_valid(data)


func cleaned_data(data, default := {}):
	var cleaned := {}
	# Convert to case insensitive defaults
	for default_key in default: 
		cleaned[default_key.to_lower()] = default[default_key]
	# Clean int/floats
	for data_key in data.keys():
		cleaned[data_key.to_lower()] = _validator.cleaned_data(data[data_key], cleaned.get(data_key.to_lower()))
	# Create output
	match _output:
		TYPE_VECTOR2: return Vector2(cleaned.x, cleaned.y)
		TYPE_VECTOR2I: return Vector2i(cleaned.x, cleaned.y)
		TYPE_VECTOR3: return Vector3(cleaned.x, cleaned.y, cleaned.z)
		TYPE_VECTOR3I: return Vector3i(cleaned.x, cleaned.y, cleaned.z)
		TYPE_COLOR: return Color(cleaned.r, cleaned.g, cleaned.b, cleaned.a if "a" in cleaned else 1.0)
		_: return data
