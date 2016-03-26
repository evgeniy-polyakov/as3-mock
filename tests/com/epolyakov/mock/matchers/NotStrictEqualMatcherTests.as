package com.epolyakov.mock.matchers
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class NotStrictEqualMatcherTests
	{
		[Test]
		public function match_ShouldReturnFalse():void
		{
			assertFalse(new NotStrictEqualMatcher(null).match(null));
			assertTrue(new NotStrictEqualMatcher(null).match(undefined));
			assertTrue(new NotStrictEqualMatcher(null).match(false));
			assertTrue(new NotStrictEqualMatcher(null).match(0));
			assertTrue(new NotStrictEqualMatcher(null).match(""));
			assertTrue(new NotStrictEqualMatcher(null).match({}));

			assertFalse(new NotStrictEqualMatcher(true).match(true));
			assertFalse(new NotStrictEqualMatcher(false).match(false));
			assertTrue(new NotStrictEqualMatcher(false).match(true));
			assertTrue(new NotStrictEqualMatcher(true).match(false));

			assertFalse(new NotStrictEqualMatcher(0).match(0));
			assertFalse(new NotStrictEqualMatcher(1).match(1));
			assertTrue(new NotStrictEqualMatcher(0).match(1));
			assertTrue(new NotStrictEqualMatcher(1).match(0));
			assertTrue(new NotStrictEqualMatcher(NaN).match(NaN));
			assertTrue(new NotStrictEqualMatcher(NaN).match(1));
			assertTrue(new NotStrictEqualMatcher(0).match(NaN));
			assertFalse(new NotStrictEqualMatcher(0.0009).match(0.0009));
			assertTrue(new NotStrictEqualMatcher(0.0009).match(0.0008));

			assertTrue(new NotStrictEqualMatcher(1).match(true));
			assertTrue(new NotStrictEqualMatcher(0).match(false));
			assertTrue(new NotStrictEqualMatcher(1).match("1"));
			assertTrue(new NotStrictEqualMatcher(0).match("0"));

			var obj:Object = {};
			assertFalse(new NotStrictEqualMatcher(obj).match(obj));
			assertTrue(new NotStrictEqualMatcher(obj).match({}));
			assertTrue(new NotStrictEqualMatcher(obj).match(Object));
			assertTrue(new NotStrictEqualMatcher(obj).match(XML));

			assertFalse(new NotStrictEqualMatcher(XML).match(XML));
			assertTrue(new NotStrictEqualMatcher(Object).match(XML));
		}

		[Test]
		public function match_AnyEqual_ShouldReturnTrue():void
		{
			var obj:Object = {};
			var matcher:NotStrictEqualMatcher = new NotStrictEqualMatcher(null, [NaN, false, true, 0, 10, "abc", obj, Object]);
			assertTrue(matcher.match(undefined));
			assertFalse(matcher.match(null));
			assertTrue(matcher.match(NaN));
			assertFalse(matcher.match(false));
			assertFalse(matcher.match(true));
			assertFalse(matcher.match(0));
			assertFalse(matcher.match(10));
			assertFalse(matcher.match("abc"));
			assertFalse(matcher.match(obj));
			assertFalse(matcher.match(Object));

			assertTrue(matcher.match(20));
			assertTrue(matcher.match("def"));
			assertTrue(matcher.match({}));
			assertTrue(matcher.match(XML));
		}

		[Test]
		public function toString_ShouldReturnName():void
		{
			assertEquals(new NotStrictEqualMatcher(null).toString(), "It.notStrictEqual(null)");
			assertEquals(new NotStrictEqualMatcher(NaN).toString(), "It.notStrictEqual(NaN)");
			assertEquals(new NotStrictEqualMatcher(true).toString(), "It.notStrictEqual(true)");
			assertEquals(new NotStrictEqualMatcher(false).toString(), "It.notStrictEqual(false)");
			assertEquals(new NotStrictEqualMatcher("abc").toString(), "It.notStrictEqual(abc)");
			assertEquals(new NotStrictEqualMatcher(0).toString(), "It.notStrictEqual(0)");
			assertEquals(new NotStrictEqualMatcher(1).toString(), "It.notStrictEqual(1)");
			assertEquals(new NotStrictEqualMatcher("a", ["b", "c"]).toString(), "It.notStrictEqual(a,b,c)");
			assertEquals(new NotStrictEqualMatcher({}).toString(), "It.notStrictEqual([object Object])");
			assertEquals(new NotStrictEqualMatcher(Object).toString(), "It.notStrictEqual([class Object])");
			assertEquals(new NotStrictEqualMatcher(null, [true, false]).toString(), "It.notStrictEqual(null,true,false)");
		}
	}
}
