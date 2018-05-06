/**
 * @package ArrayMap and ArraySet
 * @author  Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @license 0BSD
 */
lib		= require('..')
test	= require('tape')

test('ArrayMap and ArraySet', (t) !->
	t.plan(8)

	map		= lib.ArrayMap()
	u8_1	= Uint8Array.of(1, 2, 3)
	u8_2	= Uint8Array.of(1, 2, 3)
	t.equal(map.size, 0, 'ArrayMap empty initially')
	t.notOk(map.has(u8_1), "ArrayMap doesn't have array initially")
	map.set(u8_1, u8_1)
	t.ok(map.has(u8_1), 'ArrayMap has item after addition')
	t.ok(map.has(u8_2), 'ArrayMap has item that is a different array, but with the same contents')

	set	= lib.ArraySet()
	t.equal(set.size, 0, 'ArraySet empty initially')
	t.notOk(set.has(u8_1), "ArraySet doesn't have array initially")
	set.add(u8_1)
	t.ok(set.has(u8_1), 'ArraySet has item after addition')
	t.ok(set.has(u8_2), 'ArraySet has item that is a different array, but with the same contents')
)
