class_name JNumberValidator extends JPropertyValidator

## Base class for handling validation and cleanup of all numbers
##
## See [JFloatValidator] and [JIntValidator] for more specific classes.

enum {
	INCLUSIVE, ## Includes a given value (e.g. a number range from 1 to 5, inclusive, means [1, 2, 3, 4, 5])
	EXCLUSIVE ## Excludes a given value (e.g. a number range from 1 to 5, exclusive, means [2, 3, 4])
}

## Defines whether the [member max] value is [enum INCLUSIVE] or [enum EXCLUSIVE]
var max_type = INCLUSIVE
## If [code]true[/code], [member max] will be taken into account during [method is_valid]
var has_max: bool = false
## If [member has_max] is [code]true[/code], valid data must be below [member max] (inclusive or exclusive depending on [member max_type])
var max = 0

## Defines whether the [member min] value is [enum INCLUSIVE] or [enum EXCLUSIVE]
var min_type = INCLUSIVE
## If [code]true[/code], [member min] will be taken into account during [method is_valid]
var has_min: bool = false
## If [member has_min] is [code]true[/code], valid data must be below [member min] (inclusive or exclusive depending on [member min_type])
var min = 0

## If [code]true[/code], [member step] will be taken into account during [method is_valid]
var has_step: bool = false
## If [member has_step] is [code]true[/code], valid data must be a multiple of [member step]
var step = 0


## Set the [member max] value (inclusive)
func set_maximum(value) -> JNumberValidator:
	max_type = INCLUSIVE
	has_max = true
	max = value
	return self


## Set the [member max] value (exclusive)
func set_maximum_exclusive(value) -> JNumberValidator:
	max_type = EXCLUSIVE
	has_max = true
	max = value
	return self


## Set the [member min] value (inclusive)
func set_minimum(value) -> JNumberValidator:
	min_type = INCLUSIVE
	has_min = true
	min = value
	return self


## Set the [member min] value (exclusive)
func set_minimum_exclusive(value) -> JNumberValidator:
	min_type = EXCLUSIVE
	has_min = true
	min = value
	return self


## Set the [member step] value (e.g. validates that a given number is a multiple of the step [code]value[/code])
func set_step(value) -> JNumberValidator:
	has_step = true
	step = value
	return self


## Returns [code]true[/code] if the provided [code]data[/code] is a valid [int] or [float] based on the properties of this [JNumberValidator] object.
## [br][b]Example:[/b]
## [codeblock]
## assert(JNumberValidator.new()
##     .set_minimum(0)
##     .set_maximum(1)
##     .is_valid(0.5))
## [/codeblock]
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



## Returns a new [JFloatValidator] from the provided JSON schema [Dictionary].
## See the [url=https://json-schema.org/understanding-json-schema/reference/numeric.html]number JSON Schema documentation[/url] for more information
## about what type of input can be provided to the [code]schema[/code] parameter.
## [br][br][b]Note:[/b] Only the following number JSON Schema features are implemented (see [method JPropertyValidator.from_schema] for JSON schema features that apply to all data types)
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/numeric.html#multiples][code]multipleOf[/code][/url] → [member step]
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/numeric.html#range][code]minimum[/code][/url] → [member min]
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/numeric.html#range][code]maximum[/code][/url] → [member max]
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/numeric.html#range][code]exclusiveMinimum[/code][/url] → [member min] (when [member min_type] is [enum EXCLUSIVE])
## [br]• [url=https://json-schema.org/understanding-json-schema/reference/numeric.html#range][code]exclusiveMaximum[/code][/url] → [member max] (when [member min_type] is [enum EXCLUSIVE])
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
