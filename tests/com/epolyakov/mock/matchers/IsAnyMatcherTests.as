package com.epolyakov.mock.matchers
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsAnyMatcherTests
	{
		[Test]
		public function match_ShouldAlwaysReturnTrue():void
		{
			var matcher:IsAnyMatcher = new IsAnyMatcher();
			assertTrue(matcher.match("some-string"));
			assertTrue(matcher.match(0));
			assertTrue(matcher.match(0.001));
			assertTrue(matcher.match(1234));
			assertTrue(matcher.match(1234.567));
			assertTrue(matcher.match(NaN));
			assertTrue(matcher.match(true));
			assertTrue(matcher.match(false));
			assertTrue(matcher.match({}));
			assertTrue(matcher.match({a: 0, b: 1}));
			assertTrue(matcher.match([]));
			assertTrue(matcher.match([0, 1]));
			assertTrue(matcher.match(new XML()));
			assertTrue(matcher.match(XML));
			assertTrue(matcher.match(Class));
		}

		[Test]
		public function toString_ShouldReturnName():void
		{
			assertEquals(new IsAnyMatcher().toString(), "It.isAny()");
		}
	}
}
