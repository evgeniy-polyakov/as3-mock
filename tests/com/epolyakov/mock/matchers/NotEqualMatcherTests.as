package com.epolyakov.mock.matchers
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class NotEqualMatcherTests
	{
		[Test]
		public function match_ShouldReturnFalse():void
		{
			assertFalse(new NotEqualMatcher(null).match(null));
			assertFalse(new NotEqualMatcher(null).match(undefined));
			assertTrue(new NotEqualMatcher(null).match(false));
			assertTrue(new NotEqualMatcher(null).match(0));
			assertTrue(new NotEqualMatcher(null).match(""));
			assertTrue(new NotEqualMatcher(null).match({}));

			assertFalse(new NotEqualMatcher(true).match(true));
			assertFalse(new NotEqualMatcher(false).match(false));
			assertTrue(new NotEqualMatcher(false).match(true));
			assertTrue(new NotEqualMatcher(true).match(false));

			assertFalse(new NotEqualMatcher(0).match(0));
			assertFalse(new NotEqualMatcher(1).match(1));
			assertTrue(new NotEqualMatcher(0).match(1));
			assertTrue(new NotEqualMatcher(1).match(0));
			assertFalse(new NotEqualMatcher(NaN).match(NaN));
			assertTrue(new NotEqualMatcher(NaN).match(1));
			assertTrue(new NotEqualMatcher(0).match(NaN));
			assertFalse(new NotEqualMatcher(0.0009).match(0.0009));
			assertTrue(new NotEqualMatcher(0.0009).match(0.0008));

			assertFalse(new NotEqualMatcher(1).match(true));
			assertFalse(new NotEqualMatcher(0).match(false));
			assertFalse(new NotEqualMatcher(1).match("1"));
			assertFalse(new NotEqualMatcher(0).match("0"));

			var obj:Object = {};
			assertFalse(new NotEqualMatcher(obj).match(obj));
			assertTrue(new NotEqualMatcher(obj).match({}));
			assertTrue(new NotEqualMatcher(obj).match(Object));
			assertTrue(new NotEqualMatcher(obj).match(XML));

			assertFalse(new NotEqualMatcher(XML).match(XML));
			assertTrue(new NotEqualMatcher(Object).match(XML));
		}

		[Test]
		public function match_AnyEqual_ShouldReturnTrue():void
		{
			var obj:Object = {};
			var matcher:NotEqualMatcher = new NotEqualMatcher(null, [NaN, false, true, 0, 10, "abc", obj, Object]);
			assertFalse(matcher.match(undefined));
			assertFalse(matcher.match(null));
			assertFalse(matcher.match(NaN));
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
			assertEquals(new NotEqualMatcher(null).toString(), "It.notNull()");
			assertEquals(new NotEqualMatcher(NaN).toString(), "It.notEqual(NaN)");
			assertEquals(new NotEqualMatcher(true).toString(), "It.notEqual(true)");
			assertEquals(new NotEqualMatcher(false).toString(), "It.notEqual(false)");
			assertEquals(new NotEqualMatcher("abc").toString(), "It.notEqual(abc)");
			assertEquals(new NotEqualMatcher(0).toString(), "It.notEqual(0)");
			assertEquals(new NotEqualMatcher(1).toString(), "It.notEqual(1)");
			assertEquals(new NotEqualMatcher("a", ["b", "c"]).toString(), "It.notEqual(a,b,c)");
			assertEquals(new NotEqualMatcher({}).toString(), "It.notEqual([object Object])");
			assertEquals(new NotEqualMatcher(Object).toString(), "It.notEqual([class Object])");
			assertEquals(new NotEqualMatcher(null, [true, false]).toString(), "It.notEqual(null,true,false)");
		}
	}
}
