package com.epolyakov.mock.matchers
{
	import flash.display.Sprite;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsLikeMatcherTests
	{
		[Test]
		public function match_ShouldReturnCheckForEquality():void
		{
			assertTrue(new IsLikeMatcher(null).match(null));
			assertTrue(new IsLikeMatcher(null).match(undefined));
			assertFalse(new IsLikeMatcher(null).match(false));
			assertFalse(new IsLikeMatcher(null).match(0));
			assertFalse(new IsLikeMatcher(null).match(""));
			assertFalse(new IsLikeMatcher(null).match({}));

			assertTrue(new IsLikeMatcher(true).match(true));
			assertTrue(new IsLikeMatcher(false).match(false));
			assertFalse(new IsLikeMatcher(false).match(true));
			assertFalse(new IsLikeMatcher(true).match(false));

			assertTrue(new IsLikeMatcher(0).match(0));
			assertTrue(new IsLikeMatcher(1).match(1));
			assertFalse(new IsLikeMatcher(0).match(1));
			assertFalse(new IsLikeMatcher(1).match(0));
			assertTrue(new IsLikeMatcher(NaN).match(NaN));
			assertFalse(new IsLikeMatcher(NaN).match(1));
			assertFalse(new IsLikeMatcher(0).match(NaN));
			assertTrue(new IsLikeMatcher(0.0009).match(0.0009));
			assertFalse(new IsLikeMatcher(0.0009).match(0.0008));

			assertTrue(new IsLikeMatcher(1).match(true));
			assertTrue(new IsLikeMatcher(0).match(false));
			assertTrue(new IsLikeMatcher(1).match("1"));
			assertTrue(new IsLikeMatcher(0).match("0"));

			var obj:Object = {};
			assertTrue(new IsLikeMatcher(obj).match(obj));
			assertTrue(new IsLikeMatcher(obj).match({}));
			assertFalse(new IsLikeMatcher(obj).match(Object));
			assertFalse(new IsLikeMatcher(obj).match(XML));

			assertTrue(new IsLikeMatcher(XML).match(XML));
			assertFalse(new IsLikeMatcher(Object).match(XML));

			assertTrue(new IsLikeMatcher(<x a="b"/>).match(<x a="b"/>));
			assertFalse(new IsLikeMatcher(<x a="b"/>).match(<x a="b" c="d"/>));
			assertTrue(new IsLikeMatcher(<x>
					<a/>
					<b/>
					</x>.children()).match(<x>
					<a/>
					<b/>
					</x>.children()));
			assertFalse(new IsLikeMatcher(<x>
					<a a="a"/>
					<b/>
					</x>.children()).match(<x>
					<a/>
					<b/>
					</x>.children()));
			assertFalse(new IsLikeMatcher(<x>
					<a/>
					<b/>
					<c/>
					</x>.children()).match(<x>
					<a/>
					<b/>
					</x>.children()));
		}

		[Test]
		public function match_ShouldReturnCheckPropertiesRecursively():void
		{
			assertTrue(new IsLikeMatcher([0, 1, 2]).match([0, 1, 2]));
			assertTrue(new IsLikeMatcher(new <int>[0, 1, 2]).match([0, 1, 2]));
			assertTrue(new IsLikeMatcher({0: 0, 1: 1, 2: 2}).match([0, 1, 2]));
			assertTrue(new IsLikeMatcher({1: 1, 0: 0, 2: 2}).match([0, 1, 2]));
			assertTrue(new IsLikeMatcher({1: 1, 0: 0, 2: NaN}).match([0, 1, NaN]));
			assertFalse(new IsLikeMatcher([0, 1, 2]).match([0, 2, 1]));
			assertFalse(new IsLikeMatcher(new <int>[0, 1, 2]).match([0, 2, 1]));

			assertTrue(new IsLikeMatcher([0, 1, [2, 3]]).match([0, 1, [2, 3]]));
			assertTrue(new IsLikeMatcher([0, 1, new <int>[2, 3]]).match([0, 1, [2, 3]]));
			assertTrue(new IsLikeMatcher([0, 1, {0: 2, 1: 3}]).match([0, 1, [2, 3]]));
			assertFalse(new IsLikeMatcher([0, 1, [2, 3]]).match([0, 1, [2, 3, 4]]));
			assertFalse(new IsLikeMatcher([0, 1, new <int>[2]]).match([0, 1, [2, 3]]));
			assertFalse(new IsLikeMatcher([0, 1, {0: 2, 1: 3, a: "a"}]).match([0, 1, [2, 3]]));

			assertTrue(new IsLikeMatcher({alpha: 1, visible: true}).match(new Sprite()));
			assertFalse(new IsLikeMatcher({alpha: 0.5, visible: true}).match(new Sprite()));
		}

		[Test]
		public function toString_ShouldReturnName():void
		{
			assertEquals(new IsLikeMatcher(null).toString(), "It.isLike(null)");
			assertEquals(new IsLikeMatcher(NaN).toString(), "It.isLike(NaN)");
			assertEquals(new IsLikeMatcher(true).toString(), "It.isLike(true)");
			assertEquals(new IsLikeMatcher(false).toString(), "It.isLike(false)");
			assertEquals(new IsLikeMatcher("abc").toString(), "It.isLike(abc)");
			assertEquals(new IsLikeMatcher(0).toString(), "It.isLike(0)");
			assertEquals(new IsLikeMatcher(1).toString(), "It.isLike(1)");
			assertEquals(new IsLikeMatcher({}).toString(), "It.isLike([object Object])");
			assertEquals(new IsLikeMatcher(Object).toString(), "It.isLike([class Object])");
			assertEquals(new IsLikeMatcher([0, 1, 2]).toString(), "It.isLike(0,1,2)");
		}
	}
}
