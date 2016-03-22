package com.epolyakov.mock.matchers
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsStrictlyEqualMatcherTests
	{
		[Test]
		public function match_ShouldReturnTrue():void
		{
			assertTrue(new IsStrictlyEqualMatcher(null).match(null));
			assertFalse(new IsStrictlyEqualMatcher(null).match(undefined));
			assertFalse(new IsStrictlyEqualMatcher(null).match(false));
			assertFalse(new IsStrictlyEqualMatcher(null).match(0));
			assertFalse(new IsStrictlyEqualMatcher(null).match(""));
			assertFalse(new IsStrictlyEqualMatcher(null).match({}));

			assertTrue(new IsStrictlyEqualMatcher(true).match(true));
			assertTrue(new IsStrictlyEqualMatcher(false).match(false));
			assertFalse(new IsStrictlyEqualMatcher(false).match(true));
			assertFalse(new IsStrictlyEqualMatcher(true).match(false));

			assertTrue(new IsStrictlyEqualMatcher(0).match(0));
			assertTrue(new IsStrictlyEqualMatcher(1).match(1));
			assertFalse(new IsStrictlyEqualMatcher(0).match(1));
			assertFalse(new IsStrictlyEqualMatcher(1).match(0));
			assertFalse(new IsStrictlyEqualMatcher(NaN).match(NaN));
			assertFalse(new IsStrictlyEqualMatcher(NaN).match(1));
			assertFalse(new IsStrictlyEqualMatcher(0).match(NaN));
			assertTrue(new IsStrictlyEqualMatcher(0.0009).match(0.0009));
			assertFalse(new IsStrictlyEqualMatcher(0.0009).match(0.0008));

			assertFalse(new IsStrictlyEqualMatcher(1).match(true));
			assertFalse(new IsStrictlyEqualMatcher(0).match(false));
			assertFalse(new IsStrictlyEqualMatcher(1).match("1"));
			assertFalse(new IsStrictlyEqualMatcher(0).match("0"));

			var obj:Object = {};
			assertTrue(new IsStrictlyEqualMatcher(obj).match(obj));
			assertFalse(new IsStrictlyEqualMatcher(obj).match({}));
			assertFalse(new IsStrictlyEqualMatcher(obj).match(Object));
			assertFalse(new IsStrictlyEqualMatcher(obj).match(XML));

			assertTrue(new IsStrictlyEqualMatcher(XML).match(XML));
			assertFalse(new IsStrictlyEqualMatcher(Object).match(XML));
		}

		[Test]
		public function match_AnyEqual_ShouldReturnTrue():void
		{
			var obj:Object = {};
			var matcher:IsStrictlyEqualMatcher = new IsStrictlyEqualMatcher(null, [NaN, false, true, 0, 10, "abc", obj, Object]);
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
			assertEquals(new IsStrictlyEqualMatcher(null).toString(), "It.isStrictlyEqual(null)");
			assertEquals(new IsStrictlyEqualMatcher(NaN).toString(), "It.isStrictlyEqual(NaN)");
			assertEquals(new IsStrictlyEqualMatcher(true).toString(), "It.isStrictlyEqual(true)");
			assertEquals(new IsStrictlyEqualMatcher(false).toString(), "It.isStrictlyEqual(false)");
			assertEquals(new IsStrictlyEqualMatcher("abc").toString(), "It.isStrictlyEqual(abc)");
			assertEquals(new IsStrictlyEqualMatcher(0).toString(), "It.isStrictlyEqual(0)");
			assertEquals(new IsStrictlyEqualMatcher(1).toString(), "It.isStrictlyEqual(1)");
			assertEquals(new IsStrictlyEqualMatcher("a", ["b", "c"]).toString(), "It.isStrictlyEqual(a,b,c)");
			assertEquals(new IsStrictlyEqualMatcher({}).toString(), "It.isStrictlyEqual([object Object])");
			assertEquals(new IsStrictlyEqualMatcher(Object).toString(), "It.isStrictlyEqual([class Object])");
			assertEquals(new IsStrictlyEqualMatcher(null, [true, false]).toString(), "It.isStrictlyEqual(null,true,false)");
		}
	}
}
