package com.epolyakov.mock.matchers
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class FunctionMatcherTests
	{
		[Test]
		public function match_ShouldReturnSameAsFunction():void
		{
			var matcher:FunctionMatcher = new FunctionMatcher(function (value:*):Boolean
			{
				return value == 1;
			});
			assertTrue(matcher.match(1));
			assertFalse(matcher.match(2));
			assertFalse(matcher.match(0));
			assertFalse(matcher.match(1.1));
			assertFalse(matcher.match(NaN));
		}

		[Test]
		[Test]
		public function toString_ShouldReturnName():void
		{
			var matcher:FunctionMatcher = new FunctionMatcher(function (value:*):Boolean
			{
				return value == 1;
			});
			assertEquals("It.match(function Function() {})", matcher.toString());
		}
	}
}
