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
			return _matcher.toString().replace("It.is", "It.not");
		}
	}
}
