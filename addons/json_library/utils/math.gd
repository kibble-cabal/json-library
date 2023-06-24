class_name JsonLibrary_Utils_Math extends Object

## If [code]true[/code], the given [code]number[/code] is rounded to the given step
## [codeblock]
## assert(Math.is_rounded(5.0))
## assert(Math.is_rounded(5.5) == false)
## assert(Math.is_rounded(1.25, 0.25))
## [/codeblock]
static func is_rounded(number, step = 1.0) -> bool:
	return (number is int or number is float) and is_zero_approx(fmod(float(number), float(step)))
