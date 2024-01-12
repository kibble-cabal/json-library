class_name JsonLibrary_Utils_Array extends Object


static func map_to_lower(array: Array) -> Array:
	return array.map(func(element: String) -> String: return element.to_lower())


static func unique(array: Array) -> Array:
	var unique_elements: Array = []
	for element in array:
		if not element in unique_elements:
			unique_elements.append(element)
	return unique_elements


static func all_elements_unique(array: Array) -> bool:
	var seen := {}
	for element in array:
		if seen.has(element): return false
		seen[element] = true
	return true
