class_name JNumberValidator extends JPropertyValidator

enum {
	INCLUSIVE,
	EXCLUSIVE
}

var max_type = INCLUSIVE
var has_max: bool = false
var max = 0

var min_type = INCLUSIVE
var has_min: bool = false
var min = 0

var has_step: bool = false
var step = 0


## Set the maximum value (inclusive)
func set_maximum(value) -> JNumberValidator:
	max_type = INCLUSIVE
	has_max = true
	max = value
	return self


## Set the maximum value (exclusive)
func set_maximum_exclusive(value) -> JNumberValidator:
	max_type = EXCLUSIVE
	has_max = true
	max = value
	return self


## Set the minimum value (inclusive)
func set_minimum(value) -> JNumberValidator:
	min_type = INCLUSIVE
	has_min = true
	min = value
	return self


## Set the minimum value (exclusive)
func set_minimum_exclusive(value) -> JNumberValidator:
	min_type = EXCLUSIVE
	has_min = true
	min = value
	return self


## Set the step value (e.g. validates that a given number is a multiple of the step [code]value[/code])
func set_step(value) -> JNumberValidator:
	has_step = true
	step = value
	return self


func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not super.is_valid(data): return false
	if not (data is float or data is int): return false
	
	var is_above_min: bool = true
	var is_below_max: bool = true
	if has_min:
		match min_type:
			EXCLUSIVE: is_above_min = data > min
			INCLUSIVE: is_above_min = data >= min
	if has_max:
		match max_type:
			EXCLUSIVE: is_below_max = data < max
			INCLUSIVE: is_below_max = data <= max
	
	return (
		is_above_min
		and is_below_max
		and (Json.Math.is_rounded(data, step) if has_step else true)
	)


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "number":
		var validator := JFloatValidator.new()
		if "minimum" in schema: validator.set_minimum(float(schema["minimum"]))
		if "exclusiveMinimum" in schema: validator.set_minimum_exclusive(float(schema["exclusiveMinimum"]))
		if "maximum" in schema: validator.set_maximum(float(schema["maximum"]))
		if "exclusiveMaximum" in schema: validator.set_maximum_exclusive(float(schema["exclusiveMaximum"]))
		if "multipleOf" in schema: validator.set_step(float(schema["multipleOf"]))
		if "enum" in schema: validator.set_options(schema["enum"])
		return validator
	return null
