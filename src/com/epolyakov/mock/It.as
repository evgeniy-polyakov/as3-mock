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
			return match(new NotMatcher(new IsEqualMatcher(value, values)));
		}

		public static function isStrictEqual(value:*, ...values):*
		{
			return match(new IsStrictEqualMatcher(value, values));
		}

		public static function notStrictEqual(value:*, ...values):*
		{
			return match(new NotMatcher(new IsStrictEqualMatcher(value, values)));
		}

		public static function isOfType(type:Class, ...types):*
		{
			return match(new IsOfTypeMatcher(type, types));
		}

		public static function notOfType(type:Class, ...types):*
		{
			return match(new NotMatcher(new IsOfTypeMatcher(type, types)));
		}

		public static function isLike(value:*):*
		{
			return match(new IsLikeMatcher(value));
		}

		public static function notLike(value:*):*
		{
			return match(new NotMatcher(new IsLikeMatcher(value)));
		}

		public static function isNull():*
		{
			return match(new IsEqualMatcher(null));
		}

		public static function notNull():*
		{
			return match(new NotMatcher(new IsEqualMatcher(null)));
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
