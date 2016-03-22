package com.epolyakov.mock.matchers
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsEqualMatcherTests
	{
		[Test]
		public function match_ShouldReturnTrue():void
		{
			assertTrue(new IsEqualMatcher(null).match(null));
			assertTrue(new IsEqualMatcher(null).match(undefined));
			assertFalse(new IsEqualMatcher(null).match(false));
			assertFalse(new IsEqualMatcher(null).match(0));
			assertFalse(new IsEqualMatcher(null).match(""));
			assertFalse(new IsEqualMatcher(null).match({}));

			assertTrue(new IsEqualMatcher(true).match(true));
			assertTrue(new IsEqualMatcher(false).match(false));
			assertFalse(new IsEqualMatcher(false).match(true));
			assertFalse(new IsEqualMatcher(true).match(false));

			assertTrue(new IsEqualMatcher(0).match(0));
			assertTrue(new IsEqualMatcher(1).match(1));
			assertFalse(new IsEqualMatcher(0).match(1));
			assertFalse(new IsEqualMatcher(1).match(0));

			assertTrue(new IsEqualMatcher(1).match(true));
			assertTrue(new IsEqualMatcher(0).match(false));
			assertTrue(new IsEqualMatcher(1).match("1"));
			assertTrue(new IsEqualMatcher(0).match("0"));

			var obj:Object = {};
			assertTrue(new IsEqualMatcher(obj).match(obj));
			assertFalse(new IsEqualMatcher(obj).match({}));
			assertFalse(new IsEqualMatcher(obj).match(Object));
			assertFalse(new IsEqualMatcher(obj).match(XML));

			assertTrue(new IsEqualMatcher(XML).match(XML));
			assertFalse(new IsEqualMatcher(Object).match(XML));
		}

		[Test]
		public function match_AnyEqual_ShouldReturnTrue():void
		{
			var obj:Object = {};
			var matcher:IsEqualMatcher = new IsEqualMatcher(null, [NaN, false, true, 0, 10, "abc", obj, Object]);
			assertTrue(matcher.match(undefined));
			assertTrue(matcher.match(null));
			assertTrue(matcher.match(NaN));
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
			assertEquals(new IsEqualMatcher(null).toString(), "It.isNull()");
			assertEquals(new IsEqualMatcher(true).toString(), "It.isTrue()");
			assertEquals(new IsEqualMatcher(false).toString(), "It.isFalse()");
			assertEquals(new IsEqualMatcher("abc").toString(), "It.isEqual(abc)");
			assertEquals(new IsEqualMatcher(0).toString(), "It.isEqual(0)");
			assertEquals(new IsEqualMatcher(1).toString(), "It.isEqual(1)");
			assertEquals(new IsEqualMatcher("a", ["b", "c"]).toString(), "It.isEqual(a,b,c)");
			assertEquals(new IsEqualMatcher({}).toString(), "It.isEqual([object Object])");
			assertEquals(new IsEqualMatcher(Object).toString(), "It.isEqual([class Object])");
			assertEquals(new IsEqualMatcher(null, [true, false]).toString(), "It.isEqual(null,true,false)");
		}
	}
}
