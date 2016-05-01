package com.epolyakov.mock
{
	import com.epolyakov.mock.matchers.FunctionMatcher;
	import com.epolyakov.mock.matchers.IsAnyMatcher;
	import com.epolyakov.mock.matchers.IsEqualMatcher;
	import com.epolyakov.mock.matchers.IsLikeMatcher;
	import com.epolyakov.mock.matchers.IsOfTypeMatcher;
	import com.epolyakov.mock.matchers.IsStrictEqualMatcher;
	import com.epolyakov.mock.matchers.NotMatcher;
	import com.epolyakov.mock.matchers.RegExpMatcher;

	import flash.display.Sprite;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class ItTests
	{
		[Before]
		public function Before():void
		{
			Mock.clear();
		}

		[Test]
		public function match_ShouldAddMatcher():void
		{
			var matcher:IMatcher = new IsAnyMatcher();
			It.match(matcher);

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertEquals(matcher, Mock.getArgumentsMatcher().matchers[0]);
		}

		[Test]
		public function match_ShouldAddFunctionMatcher():void
		{
			It.match(function (value:*):Boolean
			{
				return value == 1;
			});

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is FunctionMatcher);
		}

		[Test]
		public function match_ShouldAddRegExpMatcher():void
		{
			It.match(/^abc$/);

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is RegExpMatcher);
			assertEquals("It.match(^abc$)", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function isEqual_ShouldAddIsEqualMatcher():void
		{
			It.isEqual("abc");

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is IsEqualMatcher);
			assertEquals("It.isEqual(abc)", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function notEqual_ShouldAddNotEqualMatcher():void
		{
			It.notEqual("abc");

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is NotMatcher);
			assertEquals("It.notEqual(abc)", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function isStrictEqual_ShouldAddIsStrictEqualMatcher():void
		{
			It.isStrictEqual("abc");

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is IsStrictEqualMatcher);
			assertEquals("It.isStrictEqual(abc)", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function notStrictEqual_ShouldAddNotStrictEqualMatcher():void
		{
			It.notStrictEqual("abc");

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is NotMatcher);
			assertEquals("It.notStrictEqual(abc)", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function isOfType_ShouldAddIsOfTypeMatcher():void
		{
			It.isOfType(Sprite);

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is IsOfTypeMatcher);
			assertEquals("It.isOfType([class Sprite])", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function notOfType_ShouldAddNotOfTypeMatcher():void
		{
			It.notOfType(Sprite);

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is NotMatcher);
			assertEquals("It.notOfType([class Sprite])", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function isLike_ShouldAddIsLikeMatcher():void
		{
			It.isLike([1, 2, 3]);

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is IsLikeMatcher);
			assertEquals("It.isLike(1,2,3)", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function notLike_ShouldAddNotLikeMatcher():void
		{
			It.notLike([1, 2, 3]);

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is NotMatcher);
			assertEquals("It.notLike(1,2,3)", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function isNull_ShouldAddIsEqualMatcher():void
		{
			It.isNull();

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is IsEqualMatcher);
			assertEquals("It.isNull()", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function notNull_ShouldAddNotEqualMatcher():void
		{
			It.notNull();

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is NotMatcher);
			assertEquals("It.notNull()", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function isTrue_ShouldAddIsEqualMatcher():void
		{
			It.isTrue();

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is IsEqualMatcher);
			assertEquals("It.isTrue()", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function isFalse_ShouldAddIsEqualMatcher():void
		{
			It.isFalse();

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is IsEqualMatcher);
			assertEquals("It.isFalse()", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function isAny_ShouldAddIsAnyMatcher():void
		{
			It.isAny();

			assertEquals(1, Mock.getArgumentsMatcher().length);
			assertTrue(Mock.getArgumentsMatcher().matchers[0] is IsAnyMatcher);
			assertEquals("It.isAny()", Mock.getArgumentsMatcher().matchers[0].toString());
		}

		[Test]
		public function manyCalls_ShouldAddManyMatchers():void
		{
			It.match(/^abc$/);
			It.isEqual("abc");
			It.notEqual("abc");
			It.isStrictEqual("abc");
			It.notStrictEqual("abc");
			It.isOfType(Sprite);
			It.notOfType(Sprite);
			It.isLike([1, 2, 3]);
			It.notLike([1, 2, 3]);
			It.isNull();
			It.notNull();
			It.isTrue();
			It.isFalse();
			It.isAny();

			assertEquals(14, Mock.getArgumentsMatcher().length);
			assertEquals("It.match(^abc$)", Mock.getArgumentsMatcher().matchers[0].toString());
			assertEquals("It.isEqual(abc)", Mock.getArgumentsMatcher().matchers[1].toString());
			assertEquals("It.notEqual(abc)", Mock.getArgumentsMatcher().matchers[2].toString());
			assertEquals("It.isStrictEqual(abc)", Mock.getArgumentsMatcher().matchers[3].toString());
			assertEquals("It.notStrictEqual(abc)", Mock.getArgumentsMatcher().matchers[4].toString());
			assertEquals("It.isOfType([class Sprite])", Mock.getArgumentsMatcher().matchers[5].toString());
			assertEquals("It.notOfType([class Sprite])", Mock.getArgumentsMatcher().matchers[6].toString());
			assertEquals("It.isLike(1,2,3)", Mock.getArgumentsMatcher().matchers[7].toString());
			assertEquals("It.notLike(1,2,3)", Mock.getArgumentsMatcher().matchers[8].toString());
			assertEquals("It.isNull()", Mock.getArgumentsMatcher().matchers[9].toString());
			assertEquals("It.notNull()", Mock.getArgumentsMatcher().matchers[10].toString());
			assertEquals("It.isTrue()", Mock.getArgumentsMatcher().matchers[11].toString());
			assertEquals("It.isFalse()", Mock.getArgumentsMatcher().matchers[12].toString());
			assertEquals("It.isAny()", Mock.getArgumentsMatcher().matchers[13].toString());
		}
	}
}
