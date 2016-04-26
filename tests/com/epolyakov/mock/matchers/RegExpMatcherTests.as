package com.epolyakov.mock.matchers
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class RegExpMatcherTests
	{
		[Test]
		public function match_ShouldTestString():void
		{
			assertTrue(new RegExpMatcher(/.*/).match(null));
			assertTrue(new RegExpMatcher(/^$/).match(null));
			assertFalse(new RegExpMatcher(/.+/).match(null));
			assertTrue(new RegExpMatcher(/abc/).match("abc"));
			assertFalse(new RegExpMatcher(/abd/).match("abc"));
			assertTrue(new RegExpMatcher(/^\[object[^\]]+\]$/).match({}));
			assertTrue(new RegExpMatcher(/^\[class[^\]]+\]$/).match(Object));
			assertFalse(new RegExpMatcher(/^\[class[^\]]+\]$/).match({}));
			assertFalse(new RegExpMatcher(/^\[object[^\]]+\]$/).match(Object));

		}

		[Test]
		public function toString_ShouldReturnName():void
		{
			assertEquals(new RegExpMatcher(/abc.*/).toString(), "It.match(abc.*)");
		}
	}
}
