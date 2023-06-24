class_name JNumberValidator extends JPropertyValidator

var _has_max: bool = false
var _max = 0

var _has_min: bool = false
var _min = 0

var _has_step: bool = false
var _step = 0


## Set the maximum value
func maximum(value) -> JNumberValidator:
	_has_max = true
	_max = value
	return self


## Set the minimum value
func minimum(value) -> JNumberValidator:
	_has_min = true
	_min = value
	return self


## Set the step value (e.g. validates that a given number is a multiple of the step [code]value[/code])
func step(value) -> JNumberValidator:
	_has_step = true
	_step = value
	return self


func is_valid(data) -> bool:
	return (
		(data is float or data is int)
		and (data >= _min if _has_min else true)
		and (data <= _max if _has_max else true)
		and (Json.Utils.Math.is_rounded(data, _step) if _has_step else true)
	)
