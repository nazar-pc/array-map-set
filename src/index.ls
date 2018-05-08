/**
 * @package ArrayMap and ArraySet
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
key_aliases	= new WeakMap
key_strings	= new Map
key_usages	= new Map
/**
 * @param {!ArrayBufferView} key
 *
 * @return {!ArrayBufferView}
 */
function get_unique_key (key)
	real_key = key_aliases.get(key)
	/**
	 * Real key is an array with unique contents that appeared first.
	 * If all of the usages were eliminated, some WeakMap can still point to old real key, which is not a real key anymore, which leads to inconsistencies.
	 * In order to resolve this we have an additional check that confirms if real key is still believed to be a real key.
	 */
	if real_key && key_usages.has(real_key)
		real_key
	else
		key_string	= key.join(',')
		# If real key already exists, use it and create alias
		if key_strings.has(key_string)
			real_key	= key_strings.get(key_string)
			key_aliases.set(key, real_key)
			real_key
		else
			key
/**
 * @param {!ArrayBufferView} key
 */
!function increase_key_usage (key)
	key_string		= key.join(',')
	current_value	= key_usages.get(key)
	# On first use of real key create WeakMap alias to itself and string alias, set number of usages to 1
	if !current_value
		key_aliases.set(key, key)
		key_strings.set(key_string, key)
		key_usages.set(key, 1)
	else
		++current_value
		key_usages.set(key, current_value)
/**
 * @param {!ArrayBufferView} key
 */
!function decrease_key_usage (key)
	key_string		= key.join(',')
	current_value	= key_usages.get(key)
	--current_value
	# When last usage was eliminated, clean string alias and usages, WeakMap will clean itself over time or upon request (we can't enumerate its keys ourselves)
	if !current_value
		key_strings.delete(key_string)
		key_usages.delete(key)
	else
		key_usages.set(key, current_value)

# LiveScript doesn't support classes, so we do it in ugly way
/**
 * This is a Map with very interesting property: different ArrayBufferViews with the same contents will be treated as the same ArrayBufferView
 *
 * Implementation keeps weak references to make the whole thing fast and efficient
 */
function ArrayMap (array)
	map = new Map
		..get = (key) ->
			key	= get_unique_key(key)
			Map::get.call(@, key)
		..has	= (key) ->
			key	= get_unique_key(key)
			Map::has.call(@, key)
		..set = (key, value) ->
			key	= get_unique_key(key)
			if !Map::has.call(@, key)
				increase_key_usage(key)
			Map::set.call(@, key, value)
		..delete = (key) ->
			key	= get_unique_key(key)
			if Map::has.call(@, key)
				decrease_key_usage(key)
			Map::delete.call(@, key)
		..clear = !->
			@forEach (, key) !~>
				@delete(key)
	if array
		for [key, value] in array
			map.set(key, value)
	map
# LiveScript doesn't support classes, so we do it in ugly way
/**
 * This is a Set with very interesting property: different ArrayBufferViews with the same contents will be treated as the same ArrayBufferView
 *
 * Implementation keeps weak references to make the whole thing fast and efficient
 */
function ArraySet (array)
	set	= new Set
		..has	= (key) ->
			key	= get_unique_key(key)
			Set::has.call(@, key)
		..add = (key) ->
			key	= get_unique_key(key)
			if !Set::has.call(@, key)
				increase_key_usage(key)
			Set::add.call(@, key)
		..delete = (key) ->
			key	= get_unique_key(key)
			if Set::has.call(@, key)
				decrease_key_usage(key)
			Set::delete.call(@, key)
		..clear = !->
			@forEach (, key) !~>
				@delete(key)
	if array
		for item in array
			set.add(item)
	set

function Wrapper
	{
		'ArrayMap'	: ArrayMap
		'ArraySet'	: ArraySet
	}

if typeof define == 'function' && define['amd']
	# AMD
	define(Wrapper)
else if typeof exports == 'object'
	# CommonJS
	module.exports = Wrapper()
else
	# Browser globals
	@'array_map_set' = Wrapper()
