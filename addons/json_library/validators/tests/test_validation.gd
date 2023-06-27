extends JTestRunner


func _init() -> void:
	tests = (
		test_json_validator()
		+ test_string_validator()
		+ test_bool_validator()
		+ test_int_validator()
		+ test_float_validator()
		+ test_vector_validator()
		+ test_enum_validator()
		+ test_array_validator()
		+ test_path_validator()
		+ test_null()
		+ test_nullable()
		+ test_dict_validator()
	)


func test_json_validator() -> Array[JTestCase]:
	return [
		# Ignore case
		JTestCase.new("is case sensitive").expect_false(
			JsonValidator.new()
				.set_case_sensitive(true)
				.add_property("a", JIntValidator.new())
				.is_valid
				.bind({ A = 1 })
		),
		JTestCase.new("is case insensitive").expect(
			JsonValidator.new()
				.set_case_sensitive(false)
				.add_property("a", JIntValidator.new())
				.is_valid
				.bind({ A = 1 })
		),
		# Has defaults
		JTestCase.new("has defaults").expect_equal(
			JsonValidator.new()
				.add_property("a", JIntValidator.new())
				.add_property("b", JIntValidator.new())
				.add_property("c", JIntValidator.new().set_is_optional(true))
				.cleaned_data
				.bind({ a = 1, b = 2 }, { a = 0, b = 0, c = 0 }),
			{ a = 1, b = 2, c = 0 }
		),
	]


func test_string_validator() -> Array[JTestCase]:
	return [
		JTestCase.new("is string").expect(JStringValidator.new().is_valid.bind("abc")),
		JTestCase.new("is not string").expect_false(JStringValidator.new().is_valid.bind(123)),
		# Minimum length
		JTestCase.new("is above minimum length").expect(JStringValidator.new().set_min_length(1).is_valid.bind("a")),
		JTestCase.new("is below minimum length").expect_false(JStringValidator.new().set_min_length(2).is_valid.bind("a")),
		# Maximum length
		JTestCase.new("is below maximum length").expect(JStringValidator.new().set_max_length(2).is_valid.bind("a")),
		JTestCase.new("is above maximum length").expect_false(JStringValidator.new().set_max_length(2).is_valid.bind("abc")),
		# Is one of options
		JTestCase.new("is one of options").expect(JStringValidator.new().set_options(["a", "b", "c"]).is_valid.bind("b")),
		JTestCase.new("is not one of options").expect_false(JStringValidator.new().set_options(["a", "b", "c"]).is_valid.bind("d")),
	]


func test_bool_validator() -> Array[JTestCase]:
	return [
		JTestCase.new("is bool").expect(JBoolValidator.new().is_valid.bind(false)),
		JTestCase.new("is not bool").expect_false(JBoolValidator.new().is_valid.bind({})),
		# Truthy/falsy conversions
		JTestCase.new("is bool truthy string").expect(JBoolValidator.new().set_allow_truthy_falsy().is_valid.bind("True")),
		JTestCase.new("is not bool truthy/falsy string").expect_false(JBoolValidator.new().set_allow_truthy_falsy().is_valid.bind("Yes")),
		JTestCase.new("is bool falsy int").expect(JBoolValidator.new().set_allow_truthy_falsy().is_valid.bind(0)),
		JTestCase.new("is not bool truthy/falsy int").expect(JBoolValidator.new().set_allow_truthy_falsy().is_valid.bind(10)),
		# Cleaned data
		JTestCase.new("cleaned truthy string").expect(JBoolValidator.new().set_allow_truthy_falsy().cleaned_data.bind("TRUE")),
		JTestCase.new("cleaned falsy int").expect_false(JBoolValidator.new().set_allow_truthy_falsy().cleaned_data.bind(0)),
	]


func test_int_validator() -> Array[JTestCase]:
	return [
		# Int
		JTestCase.new("is not int").expect(JIntValidator.new().is_valid.bind(1)),
		JTestCase.new("is not int").expect_false(JIntValidator.new().is_valid.bind(0.5)),
		# Minimum
		JTestCase.new("is above minimum").expect(JIntValidator.new().set_minimum(1).is_valid.bind(1)),
		JTestCase.new("is below minimum").expect_false(JIntValidator.new().set_minimum(1).is_valid.bind(-1)),
		JTestCase.new("is below minimum (exclusive)").expect_false(JIntValidator.new().set_minimum_exclusive(1).is_valid.bind(1)),
		# Maximum
		JTestCase.new("is below maximum").expect(JIntValidator.new().set_maximum(5).is_valid.bind(3)),
		JTestCase.new("is above maximum").expect_false(JIntValidator.new().set_maximum(-1).is_valid.bind(3)),
		JTestCase.new("is above maximum (exclusive)").expect_false(JIntValidator.new().set_maximum_exclusive(-1).is_valid.bind(-1)),
		# Step
		JTestCase.new("is multiple of 3").expect(JIntValidator.new().set_step(3).is_valid.bind(6)),
		JTestCase.new("if not multiple of 3").expect_false(JIntValidator.new().set_step(3).is_valid.bind(7)),
		# Cleaned data
		JTestCase.new("is cleaned").expect_equal(JIntValidator.new().cleaned_data.bind(1.0), 1),
		# Is one of options
		JTestCase.new("is one of options").expect(JIntValidator.new().set_options([1, 2, 3]).is_valid.bind(2)),
		JTestCase.new("is not one of options").expect_false(JIntValidator.new().set_options([1, 2, 3]).is_valid.bind(-1)),
	]


func test_float_validator() -> Array[JTestCase]:
	return [
		# Minimum
		JTestCase.new("is above minimum").expect(JFloatValidator.new().set_minimum(1).is_valid.bind(1)),
		JTestCase.new("is below minimum").expect_false(JFloatValidator.new().set_minimum(1).is_valid.bind(-1)),
		# Maximum
		JTestCase.new("is below maximum").expect(JFloatValidator.new().set_maximum(5).is_valid.bind(3)),
		JTestCase.new("is above maximum").expect_false(JFloatValidator.new().set_maximum(-1).is_valid.bind(3)),
		# Step
		JTestCase.new("is multiple of 0.1").expect(JFloatValidator.new().set_step(0.1).is_valid.bind(0.2)),
		JTestCase.new("is not multiple of 0.1").expect_false(JFloatValidator.new().set_step(0.1).is_valid.bind(0.25)),
	]


func test_vector_validator() -> Array[JTestCase]:
	return [
		# Vector type
		JTestCase.new("is vector").expect(JVectorValidator.new().is_valid.bind({})),
		JTestCase.new("is not vector").expect_false(JVectorValidator.new().is_valid.bind(true)),
		# Required keys
		JTestCase.new("has all required keys").expect(JVectorValidator.new().vec2().is_valid.bind({ x = 1, y = 2 })),
		JTestCase.new("missing required keys").expect_false(JVectorValidator.new().vec2().is_valid.bind({ x = 1 })),
		JTestCase.new("missing optional properties").expect(JVectorValidator.new().vec2().all_optional().is_valid.bind({})),
		# Allow extra properties
		JTestCase.new("extra keys allowed").expect(JVectorValidator.new().vec2().set_additional_properties().is_valid.bind({ x = 1, y = 2, z = 3 })),
		JTestCase.new("no extra keys allowed").expect_false(JVectorValidator.new().vec2().is_valid.bind({ x = 1, y = 2, z = 3 })),
		# Int
		JTestCase.new("is int").expect(JVectorValidator.new().vec2i().is_valid.bind({ x = 1, y = 2 })),
		JTestCase.new("is not int").expect_false(JVectorValidator.new().vec2i().is_valid.bind({ x = 1.5, y = 2.5 })),
		# Minimum
		JTestCase.new("is above minimum").expect(JVectorValidator.new().vec2().set_minimum(0.0).is_valid.bind({ x = 1, y = 2 })),
		JTestCase.new("is below maximum").expect_false(JVectorValidator.new().vec2().set_minimum(0.0).is_valid.bind({ x = -1, y = 2 })),
		# Maximum
		JTestCase.new("is below maximum").expect(JVectorValidator.new().vec2().set_maximum(1.0).is_valid.bind({ x = 0.1, y = 0.2 })),
		JTestCase.new("is above maximum").expect_false(JVectorValidator.new().vec2().set_maximum(1.0).is_valid.bind({ x = 1, y = 2 })),
		# Step
		JTestCase.new("is multiple of 0.25").expect(JVectorValidator.new().vec2().set_step(0.25).is_valid.bind({ x = 0.25, y = 0.5 })),
		JTestCase.new("is not multiple of 0.25").expect_false(JVectorValidator.new().vec2().set_step(0.25).is_valid.bind({ x = 0.1, y = 0.2 })),
		# Cleaned data
		JTestCase.new("is cleaned Vector2").expect_equal(JVectorValidator.new().vec2().cleaned_data.bind({ X = 1, Y = 2 }), Vector2(1, 2)),
		JTestCase.new("is cleaned Vector2i").expect_equal(JVectorValidator.new().vec2i().cleaned_data.bind({ X = 1, Y = 2 }), Vector2i(1, 2)),
		JTestCase.new("is cleaned Vector3").expect_equal(JVectorValidator.new().vec3().cleaned_data.bind({ x = 1.5, y = 2.5, z = 3.5 }), Vector3(1.5, 2.5, 3.5)),
		JTestCase.new("is cleaned Vector3i").expect_equal(JVectorValidator.new().vec3i().cleaned_data.bind({ x = 1, y = 2, z = 3 }), Vector3i(1, 2, 3)),
		JTestCase.new("is cleaned Vector4").expect_equal(JVectorValidator.new().vec4().cleaned_data.bind({ x = 1.5, y = 2.5, z = 3.5, w = 4.5 }), Vector4(1.5, 2.5, 3.5, 4.5)),
		JTestCase.new("is cleaned Vector4i").expect_equal(JVectorValidator.new().vec4i().cleaned_data.bind({ x = 1, y = 2, z = 3, w = 4 }), Vector4i(1, 2, 3, 4)),
		JTestCase.new("is cleaned Color").expect_equal(JVectorValidator.new().color().cleaned_data.bind({ r = 0, g = 0, b = 0 }), Color(0, 0, 0, 1)),
		JTestCase.new("is cleaned Color with alpha").expect_equal(JVectorValidator.new().color().cleaned_data.bind({ r = 0, g = 0, b = 0, a = 0 }), Color(0, 0, 0, 0)),
		JTestCase.new("is cleaned Vector2 with default").expect_equal(JVectorValidator.new().vec2().cleaned_data.bind({ x = 0 }, { x = 1, y = 1 }), Vector2(0, 1)),
	]

enum Test_JsonTestEnum {
	A = 0,
	B = 1
}

func test_enum_validator() -> Array[JTestCase]:
	return [
		JTestCase.new("is enum key").expect_false(JEnumValidator.new(Test_JsonTestEnum).is_valid.bind(0)),
		JTestCase.new("is in enum").expect(JEnumValidator.new(Test_JsonTestEnum).is_valid.bind("A")),
		JTestCase.new("is not in enum").expect_false(JEnumValidator.new(Test_JsonTestEnum).is_valid.bind("C")),
		JTestCase.new("is case ignored").expect(JEnumValidator.new(Test_JsonTestEnum).set_case_sensitive(false).is_valid.bind("a")),
		JTestCase.new("is case not ignored").expect_false(JEnumValidator.new(Test_JsonTestEnum).is_valid.bind("a")),
		JTestCase.new("is cleaned").expect_equal(JEnumValidator.new(Test_JsonTestEnum).cleaned_data.bind("A"), 0),
	]


func test_array_validator() -> Array[JTestCase]:
	return [
		JTestCase.new("is int array").expect(JArrayValidator.new().set_element_validator(JIntValidator.new()).is_valid.bind([1, 2, 3])),
		JTestCase.new("is not int array").expect_false(JArrayValidator.new().set_element_validator(JIntValidator.new()).is_valid.bind(["1", "2", "3"])),
		# Minimum size
		JTestCase.new("is above minimum size").expect(JArrayValidator.new().set_min_size(1).set_element_validator(JIntValidator.new()).is_valid.bind([1, 2])),
		JTestCase.new("is below minimum size").expect_false(JArrayValidator.new().set_min_size(3).set_element_validator(JIntValidator.new()).is_valid.bind([1, 2])),
		# Maximum size
		JTestCase.new("is below maximum size").expect(JArrayValidator.new().set_max_size(3).set_element_validator(JIntValidator.new()).is_valid.bind([1, 2])),
		JTestCase.new("is above maximum size").expect_false(JArrayValidator.new().set_max_size(1).set_element_validator(JIntValidator.new()).is_valid.bind([1, 2])),
		# Cleaned data
		JTestCase.new("cleaned bool array").expect_equal(JArrayValidator.new().set_element_validator(JBoolValidator.new().set_allow_truthy_falsy()).cleaned_data.bind(["true", "false"]), [true, false]),
		JTestCase.new("cleaned bool array mismatched").expect_not_equal(JArrayValidator.new().set_element_validator(JBoolValidator.new().set_allow_truthy_falsy()).cleaned_data.bind(["true", "false"]), [false, true]),
		# Is one of options
		JTestCase.new("is one of options").expect(JArrayValidator.new().set_options([[1, 2], [3, 4]]).is_valid.bind([1, 2])),
		JTestCase.new("is not one of options").expect_false(JArrayValidator.new().set_options([[1, 2], [3, 4]]).is_valid.bind([5, 6])),
		# Unique elements
		JTestCase.new("all elements unique").expect(JArrayValidator.new().set_unique_elements().is_valid.bind([1, 2, 3])),
		JTestCase.new("not all elements unique").expect_false(JArrayValidator.new().set_unique_elements().is_valid.bind([1,1, 1])),
	]


func test_path_validator() -> Array[JTestCase]:
	return [
		JTestCase.new("is path").expect(JPathValidator.new().is_valid.bind("user://mods")),
		JTestCase.new("is not path").expect_false(JPathValidator.new().is_valid.bind(123)),
		# Extensions
		JTestCase.new("is image").expect(JPathValidator.new().image().is_valid.bind("my_image.png")),
		JTestCase.new("is not image").expect_false(JPathValidator.new().image().is_valid.bind("my_resource.tres")),
		# Existing
		JTestCase.new("exists").expect(JPathValidator.new().set_should_exist().is_valid.bind(get_stack()[0].source)),
		JTestCase.new("does not exist").expect_false(JPathValidator.new().set_should_exist().is_valid.bind("my/random/path/file.gd")),
		# Directory
		JTestCase.new("is directory").expect(
			JPathValidator.new()
				.directory()
				.set_should_exist()
				.is_valid
				.bind(Json.Path.new(get_stack()[0].source).directory())
		),
		JTestCase.new("is not file").expect_false(
			JPathValidator.new()
				.file()
				.set_should_exist()
				.is_valid
				.bind(Json.Path.new(get_stack()[0].source).directory())
		),
		# Cleaned data
		JTestCase.new("cleaned path").expect_equal(JPathValidator.new().image().cleaned_data.bind("my//path///my_image.png"), "my/path/my_image.png"),
		# Is one of options
		JTestCase.new("is one of options").expect(JPathValidator.new().set_options(["user://", "res://"]).is_valid.bind("user://")),
		JTestCase.new("is not one of options").expect_false(JPathValidator.new().set_options(["user://", "res://"]).is_valid.bind("mods://")),
	]


static func test_null() -> Array[JTestCase]:
	return [
		JTestCase.new("is null").expect(JNullValidator.new().is_valid.bind(null)),
		JTestCase.new("is not null").expect_false(JNullValidator.new().is_valid.bind("hello world")),
		JTestCase.new("has null property").expect(
			JsonValidator.new()
				.add_property("null_field", JNullValidator.new())
				.is_valid
				.bind({ null_field = null })
		),
		JTestCase.new("has non-null property").expect_false(
			JsonValidator.new()
				.add_property("null_field", JNullValidator.new())
				.is_valid
				.bind({ null_field = "hello world" })
		),
	]


static func test_nullable() -> Array[JTestCase]:
	return [
		JTestCase.new("nullable string").expect(JStringValidator.new().set_is_nullable().is_valid.bind(null)),
		JTestCase.new("non-nullable string").expect_false(JStringValidator.new().is_valid.bind(null)),
		JTestCase.new("has nullable property").expect(
			JsonValidator.new()
				.add_property("nullable_field", JStringValidator.new().set_is_nullable())
				.is_valid
				.bind({ nullable_field = null })
		),
		JTestCase.new("has non-nullable property").expect_false(
			JsonValidator.new()
				.add_property("non_nullable_field", JStringValidator.new())
				.is_valid
				.bind({ non_nullable_field = null })
		),
	]


static func test_dict_validator() -> Array[JTestCase]:
	return [
		JTestCase.new("is dictionary").expect(JDictValidator.new().is_valid.bind({ my_key = true })),
		JTestCase.new("is not dictionary").expect_false(JDictValidator.new().is_valid.bind(true)),
		# Key, value validators
		JTestCase.new("is [String, bool] dictionary").expect(
			JDictValidator
				.new()
				.set_key_validator(JStringValidator.new())
				.set_value_validator(JBoolValidator.new())
				.is_valid
				.bind({ my_key = true })
		),
		JTestCase.new("is not [String, bool] dictionary").expect_false(
			JDictValidator
				.new()
				.set_key_validator(JStringValidator.new())
				.set_value_validator(JBoolValidator.new())
				.is_valid
				.bind({ my_key = 1 })
		),
		JTestCase.new("is not [String, bool] dictionary (mixed keys)").expect_false(
			JDictValidator
				.new()
				.set_key_validator(JStringValidator.new())
				.set_value_validator(JBoolValidator.new())
				.is_valid
				.bind({ "my_key": true, 1: true })
		),
		# Required keys
		JTestCase.new("has required key").expect(JDictValidator.new().set_required_keys(["my_key"]).is_valid.bind({ my_key = true })),
		JTestCase.new("missing required key").expect_false(JDictValidator.new().set_required_keys(["my_key"]).is_valid.bind({})),
		# Is one of options
		JTestCase.new("is one of options").expect(JDictValidator.new().set_options([{ a = true }, { b = true }]).is_valid.bind({ a = true })),
		JTestCase.new("is not one of options").expect_false(JDictValidator.new().set_options([{ a = true }, { b = true }]).is_valid.bind({ c = true })),
	]
