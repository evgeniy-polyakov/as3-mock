package com.epolyakov.mock.matchers
{
	import com.epolyakov.mock.IMatcher;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class NotMatcher implements IMatcher
	{
		private var _matcher:IMatcher;

		public function NotMatcher(matcher:IMatcher)
		{
			_matcher = matcher;
		}

		public function match(value:*):Boolean
		{
			return !_matcher.match(value);
		}

		public function toString():String
		{
			var s:String = _matcher.toString();
			if (s == "It.isTrue()")
			{
				return "It.isFalse()";
			}
			if (s == "It.isFalse()")
			{
				return "It.isTrue()";
			}
			return s.replace("It.is", "It.not");
		}
	}
}
