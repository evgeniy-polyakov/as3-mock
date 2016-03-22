package com.epolyakov.mock
{
	import com.epolyakov.mock.matchers.FunctionMatcher;
	import com.epolyakov.mock.matchers.IsAnyMatcher;
	import com.epolyakov.mock.matchers.IsEqualMatcher;
	import com.epolyakov.mock.matchers.IsOfTypeMatcher;
	import com.epolyakov.mock.matchers.IsStrictEqualMatcher;
	import com.epolyakov.mock.matchers.NotEqualMatcher;
	import com.epolyakov.mock.matchers.NotOfTypeMatcher;
	import com.epolyakov.mock.matchers.NotStrictEqualMatcher;
	import com.epolyakov.mock.matchers.RegExpMatcher;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class It
	{
		public static function match(matcher:*):*
		{
			if (matcher is IMatcher)
			{
				Mock.getArgumentsMatcher().addMatcher(matcher);
			}
			else if (matcher is Function)
			{
				Mock.getArgumentsMatcher().addMatcher(new FunctionMatcher(matcher));
			}
			else if (matcher is RegExp)
			{
				Mock.getArgumentsMatcher().addMatcher(new RegExpMatcher(matcher as RegExp));
			}
			else
			{
				throw new MockSetupError("Expected argument matcher of type IMatcher, Function or RegExp, but got " + matcher);
			}
			return undefined;
		}

		public static function isEqual(value:*, ...values):*
		{
			return match(new IsEqualMatcher(value, values));
		}

		public static function notEqual(value:*, ...values):*
		{
			return match(new NotEqualMatcher(value, values));
		}

		public static function isStrictEqual(value:*, ...values):*
		{
			return match(new IsStrictEqualMatcher(value, values));
		}

		public static function notStrictEqual(value:*, ...values):*
		{
			return match(new NotStrictEqualMatcher(value, values));
		}

		public static function isOfType(type:Class, ...types):*
		{
			return match(new IsOfTypeMatcher(type, types));
		}

		public static function notOfType(type:Class, ...types):*
		{
			return match(new NotOfTypeMatcher(type, types));
		}

		public static function isNull():*
		{
			return match(new IsEqualMatcher(null));
		}

		public static function notNull():*
		{
			return match(new NotEqualMatcher(null));
		}

		public static function isFalse():Boolean
		{
			return match(new IsEqualMatcher(false));
		}

		public static function isTrue():Boolean
		{
			return match(new IsEqualMatcher(true));
		}

		public static function isAny():*
		{
			return match(new IsAnyMatcher());
		}
	}
}
