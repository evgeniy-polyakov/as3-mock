package com.epolyakov.mock
{
	import com.epolyakov.mock.matchers.IsAnyMatcher;
	import com.epolyakov.mock.matchers.IsEqualMatcher;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class ArgumentsMatcherTests
	{
		[Test]
		public function addMatcher_ShouldAddMatcher():void
		{
			var matcher1:IMatcher = new IsAnyMatcher();
			var matcher2:IMatcher = new IsEqualMatcher(0);
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();

			assertEquals(0, argumentsMatcher.matchers.length);
			argumentsMatcher.addMatcher(matcher1);
			assertEquals(1, argumentsMatcher.matchers.length);
			assertEquals(matcher1, argumentsMatcher.matchers[0]);
			argumentsMatcher.addMatcher(matcher2);
			assertEquals(2, argumentsMatcher.matchers.length);
			assertEquals(matcher1, argumentsMatcher.matchers[0]);
			assertEquals(matcher2, argumentsMatcher.matchers[1]);
		}

		[Test]
		public function passArguments_NoMatchers_ShouldSetIsEqual():void
		{
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();
			var args:Array = [undefined, null, NaN, 0, 1, true, false, "string", {}, [], Class];

			argumentsMatcher.passArguments(args.slice());

			assertEquals(args.length, argumentsMatcher.matchers.length);
			for (var i:int = 0; i < args.length; i++)
			{
				assertTrue(argumentsMatcher.matchers[i] is IsEqualMatcher);
				assertTrue(argumentsMatcher.matchers[i].match(args[i]));
			}
		}

		[Test]
		public function passArguments_NoArguments_ShouldNotSetIsEqual():void
		{
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();
			argumentsMatcher.passArguments([]);
			assertEquals(0, argumentsMatcher.matchers.length);
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function passArguments_NoArguments_ShouldThrow():void
		{
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.passArguments([]);
			assertEquals(0, argumentsMatcher.matchers.length);
		}

		[Test]
		public function passArguments_MatchersForDefaultValues_ShouldSetIsEqual():void
		{
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();
			var args:Array = [undefined, 1, true, null, NaN, "string", 0, false, {}, [], Class];

			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			var matchers:int = argumentsMatcher.matchers.length;
			argumentsMatcher.passArguments(args.slice());

			assertEquals(args.length, argumentsMatcher.matchers.length);
			for (var i:int = 0; i < args.length; i++)
			{
				if (argumentsMatcher.matchers[i] is IsEqualMatcher)
				{
					assertTrue(argumentsMatcher.matchers[i].match(args[i]));
				}
				else
				{
					assertTrue(argumentsMatcher.matchers[i] is IsAnyMatcher);
					matchers--;
				}
			}
			assertEquals(0, matchers);
		}

		[Test]
		public function passArguments_MatchersForAll_ShouldNotSetIsEqual():void
		{
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();
			var args:Array = [undefined, 1, true, null, NaN, "string", 0, false, {}, [], Class];
			var matchers:Array = [];
			var i:int;
			for (i = 0; i < args.length; i++)
			{
				matchers.push(new IsAnyMatcher());
				argumentsMatcher.addMatcher(matchers[i]);
			}
			for (i = 0; i < args.length; i++)
			{
				assertEquals(matchers[i], argumentsMatcher.matchers[i]);
			}
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function passArguments_LessMatchersForDefaultValues_ShouldThrow():void
		{
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();
			var args:Array = [undefined, 1, true, null, NaN, "string", 0, false, {}, [], Class];

			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.passArguments(args.slice());
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function passArguments_MoreMatchersForDefaultValues_ShouldThrow():void
		{
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();
			var args:Array = [undefined, 1, true, null, NaN, "string", 0, false, {}, [], Class];

			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.passArguments(args.slice());
		}

		[Test]
		public function match_NoArray_ShouldReturnFalse():void
		{
			assertFalse(new ArgumentsMatcher().match("string"));
			assertFalse(new ArgumentsMatcher().match(10));
			assertFalse(new ArgumentsMatcher().match({}));
			assertTrue(new ArgumentsMatcher().match([]));
		}

		[Test]
		public function match_ArrayLengthNotEqual_ShouldReturnFalse():void
		{
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsAnyMatcher());

			assertFalse(argumentsMatcher.match([0]));
			assertFalse(argumentsMatcher.match([0, 1, 2]));
			assertTrue(argumentsMatcher.match([0, 1]));
		}

		[Test]
		public function match_ShouldMatchAllArguments():void
		{
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();
			var args:Array = [undefined, null, NaN, 0, 1, true, false, "string", {}, [], Class];
			argumentsMatcher.passArguments(args.slice());

			assertTrue(argumentsMatcher.match(args));
			args[2] = 2;
			assertFalse(argumentsMatcher.match(args));
			args[2] = NaN;
			assertTrue(argumentsMatcher.match(args));
		}

		[Test]
		public function toString_ShouldConcatAllMatchers():void
		{
			var argumentsMatcher:ArgumentsMatcher = new ArgumentsMatcher();
			argumentsMatcher.addMatcher(new IsAnyMatcher());
			argumentsMatcher.addMatcher(new IsEqualMatcher(1));
			argumentsMatcher.addMatcher(new IsEqualMatcher(2));

			assertEquals("It.isAny(),It.isEqual(1),It.isEqual(2)", argumentsMatcher.toString());
		}
	}
}
