package com.epolyakov.mock.matchers
{
	import flash.display.IBitmapDrawable;
	import flash.events.EventDispatcher;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class NotMatcherTests
	{
		[Test]
		public function match_ShouldReturnNegateResult():void
		{
			assertFalse(new NotMatcher(new IsAnyMatcher()).match({}));
			assertFalse(new NotMatcher(new IsEqualMatcher(true)).match(true));
			assertTrue(new NotMatcher(new IsEqualMatcher(true)).match(false));
		}

		[Test]
		public function toString_ShouldReturnName():void
		{
			assertEquals(new NotMatcher(new IsEqualMatcher(null)).toString(), "It.notNull()");
			assertEquals(new NotMatcher(new IsEqualMatcher(true)).toString(), "It.isFalse()");
			assertEquals(new NotMatcher(new IsEqualMatcher(false)).toString(), "It.isTrue()");
			assertEquals(new NotMatcher(new IsEqualMatcher(NaN)).toString(), "It.notEqual(NaN)");
			assertEquals(new NotMatcher(new IsEqualMatcher("abc")).toString(), "It.notEqual(abc)");
			assertEquals(new NotMatcher(new IsEqualMatcher(0)).toString(), "It.notEqual(0)");
			assertEquals(new NotMatcher(new IsEqualMatcher(1)).toString(), "It.notEqual(1)");
			assertEquals(new NotMatcher(new IsEqualMatcher("a", ["b", "c"])).toString(), "It.notEqual(a,b,c)");
			assertEquals(new NotMatcher(new IsEqualMatcher({})).toString(), "It.notEqual([object Object])");
			assertEquals(new NotMatcher(new IsEqualMatcher(Object)).toString(), "It.notEqual([class Object])");
			assertEquals(new NotMatcher(new IsEqualMatcher(null, [true, false])).toString(), "It.notEqual(null,true,false)");

			assertEquals(new NotMatcher(new IsStrictEqualMatcher(null)).toString(), "It.notStrictEqual(null)");
			assertEquals(new NotMatcher(new IsStrictEqualMatcher(true)).toString(), "It.notStrictEqual(true)");
			assertEquals(new NotMatcher(new IsStrictEqualMatcher(false)).toString(), "It.notStrictEqual(false)");
			assertEquals(new NotMatcher(new IsStrictEqualMatcher(NaN)).toString(), "It.notStrictEqual(NaN)");
			assertEquals(new NotMatcher(new IsStrictEqualMatcher("abc")).toString(), "It.notStrictEqual(abc)");
			assertEquals(new NotMatcher(new IsStrictEqualMatcher(0)).toString(), "It.notStrictEqual(0)");
			assertEquals(new NotMatcher(new IsStrictEqualMatcher(1)).toString(), "It.notStrictEqual(1)");
			assertEquals(new NotMatcher(new IsStrictEqualMatcher("a", ["b", "c"])).toString(), "It.notStrictEqual(a,b,c)");
			assertEquals(new NotMatcher(new IsStrictEqualMatcher({})).toString(), "It.notStrictEqual([object Object])");
			assertEquals(new NotMatcher(new IsStrictEqualMatcher(Object)).toString(), "It.notStrictEqual([class Object])");
			assertEquals(new NotMatcher(new IsStrictEqualMatcher(null, [true, false])).toString(), "It.notStrictEqual(null,true,false)");

			assertEquals(new NotMatcher(new IsOfTypeMatcher(Object)).toString(), "It.notOfType([class Object])");
			assertEquals(new NotMatcher(new IsOfTypeMatcher(EventDispatcher, [IBitmapDrawable])).toString(), "It.notOfType([class EventDispatcher],[class IBitmapDrawable])");
		}
	}
}
