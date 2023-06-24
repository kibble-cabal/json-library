class_name JTestCase extends Object

var assertion_callable: Callable
var description: String
var error_description: String = ""
var stack: Array[Dictionary] = []

var found
var expected
var should_match_expected := true

var is_ok: bool:
	get:
		var _is_ok = (
			is_equal_approx(found, expected) if expected is float
			else found == expected
		)
		return _is_ok == should_match_expected


var calling_function: String:
	get: return stack[1].function if stack.size() >= 2 else ""


func _init(description_value: String = "", error_description_value: String = "") -> void:
	description = description_value
	error_description = error_description_value
	stack = get_stack()


func expect_equal(assertion_value: Callable, expected_value) -> JTestCase:
	assertion_callable = assertion_value
	expected = expected_value
	return self


func expect_not_equal(assertion_value: Callable, expected_value) -> JTestCase:
	assertion_callable = assertion_value
	expected = expected_value
	should_match_expected = false
	return self


func expect(assertion_value: Callable) -> JTestCase:
	return expect_equal(assertion_value, true)


func expect_false(assertion_value: Callable) -> JTestCase:
	return expect_equal(assertion_value, false)


func describe(description_value: String) -> JTestCase:
	description = description_value
	return self


func report_assertion_callable_function() -> String:
	return "<{caller}>.{method}({args})".format({
		caller = assertion_callable.get_object().get_script().resource_path.replace("res://", ""),
		method = assertion_callable.get_method(),
		args = assertion_callable.get_bound_arguments()
	})


func report() -> String:
	return "{caller} [color=white]{description}...[/color] {status}".format({
		caller = report_caller(),
		description = description, 
		status = "[color=green]ok![/color]" if is_ok else "[color=red]error![/color]"
	})


func report_caller() -> String:
	return "[color=gray][test:{caller}][/color]".format({ 
		caller = calling_function
	})


func report_error() -> String:
	return "[test:{caller} \"{description}\"] Test case failed: expected `{expected}`, found `{found}`{detail}".format({ 
		expected = expected,
		found = found,
		description = description,
		caller = calling_function,
		detail = "\n\t--> " + error_description if error_description.length() else ""
	})


func test() -> void:
	var results := get_test_results()
	print_rich(report_caller(), results.report)
	assert(results.is_ok, results.error_report)


func get_test_results() -> Dictionary:
	found = assertion_callable.call()
	var report := report()
	return {
		stack = stack,
		report = report(),
		is_ok = is_ok,
		error_report = report_error()
	}
	
