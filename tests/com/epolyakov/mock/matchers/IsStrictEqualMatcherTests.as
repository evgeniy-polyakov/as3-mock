package com.epolyakov.mock.matchers
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsStrictEqualMatcherTests
	{
		[Test]
		public function match_ShouldReturnTrue():void
		{
			assertTrue(new IsStrictEqualMatcher(null).match(null));
			assertFalse(new IsStrictEqualMatcher(null).match(undefined));
			assertFalse(new IsStrictEqualMatcher(null).match(false));
			assertFalse(new IsStrictEqualMatcher(null).match(0));
			assertFalse(new IsStrictEqualMatcher(null).match(""));
			assertFalse(new IsStrictEqualMatcher(null).match({}));

			assertTrue(new IsStrictEqualMatcher(true).match(true));
			assertTrue(new IsStrictEqualMatcher(false).match(false));
			assertFalse(new IsStrictEqualMatcher(false).match(true));
			assertFalse(new IsStrictEqualMatcher(true).match(false));

			assertTrue(new IsStrictEqualMatcher(0).match(0));
			assertTrue(new IsStrictEqualMatcher(1).match(1));
			assertFalse(new IsStrictEqualMatcher(0).match(1));
			assertFalse(new IsStrictEqualMatcher(1).match(0));
			assertFalse(new IsStrictEqualMatcher(NaN).match(NaN));
			assertFalse(new IsStrictEqualMatcher(NaN).match(1));
			assertFalse(new IsStrictEqualMatcher(0).match(NaN));
			assertTrue(new IsStrictEqualMatcher(0.0009).match(0.0009));
			assertFalse(new IsStrictEqualMatcher(0.0009).match(0.0008));

			assertFalse(new IsStrictEqualMatcher(1).match(true));
			assertFalse(new IsStrictEqualMatcher(0).match(false));
			assertFalse(new IsStrictEqualMatcher(1).match("1"));
			assertFalse(new IsStrictEqualMatcher(0).match("0"));

			var obj:Object = {};
			assertTrue(new IsStrictEqualMatcher(obj).match(obj));
			assertFalse(new IsStrictEqualMatcher(obj).match({}));
			assertFalse(new IsStrictEqualMatcher(obj).match(Object));
			assertFalse(new IsStrictEqualMatcher(obj).match(XML));

			assertTrue(new IsStrictEqualMatcher(XML).match(XML));
			assertFalse(new IsStrictEqualMatcher(Object).match(XML));
		}

		[Test]
		public function match_AnyEqual_ShouldReturnTrue():void
		{
			var obj:Object = {};
			var matcher:IsStrictEqualMatcher = new IsStrictEqualMatcher(null, [NaN, false, true, 0, 10, "abc", obj, Object]);
			assertFalse(matcher.match(undefined));
			assertTrue(matcher.match(null));
			assertFalse(matcher.match(NaN));
			assertTrue(matcher.match(false));
			assertTrue(matcher.match(true));
			assertTrue(matcher.match(0));
			assertTrue(matcher.match(10));
			assertTrue(matcher.match("abc"));
			assertTrue(matcher.match(obj));
			assertTrue(matcher.match(Object));

			assertFalse(matcher.match(20));
			assertFalse(matcher.match("def"));
			assertFalse(matcher.match({}));
			assertFalse(matcher.match(XML));
		}

		[Test]
		public function toString_ShouldReturnName():void
		{
			assertEquals(new IsStrictEqualMatcher(null).toString(), "It.isStrictEqual(null)");
			assertEquals(new IsStrictEqualMatcher(NaN).toString(), "It.isStrictEqual(NaN)");
			assertEquals(new IsStrictEqualMatcher(true).toString(), "It.isStrictEqual(true)");
			assertEquals(new IsStrictEqualMatcher(false).toString(), "It.isStrictEqual(false)");
			assertEquals(new IsStrictEqualMatcher("abc").toString(), "It.isStrictEqual(abc)");
			assertEquals(new IsStrictEqualMatcher(0).toString(), "It.isStrictEqual(0)");
			assertEquals(new IsStrictEqualMatcher(1).toString(), "It.isStrictEqual(1)");
			assertEquals(new IsStrictEqualMatcher("a", ["b", "c"]).toString(), "It.isStrictEqual(a,b,c)");
			assertEquals(new IsStrictEqualMatcher({}).toString(), "It.isStrictEqual([object Object])");
			assertEquals(new IsStrictEqualMatcher(Object).toString(), "It.isStrictEqual([class Object])");
			assertEquals(new IsStrictEqualMatcher(null, [true, false]).toString(), "It.isStrictEqual(null,true,false)");
		}
	}
}
