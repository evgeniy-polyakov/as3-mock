package com.epolyakov.mock.matchers
{
	import com.epolyakov.mock.IMatcher;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsAnyMatcher implements IMatcher
	{
		public function match(value:*):Boolean
		{
			return true;
		}

		public function toString():String
		{
			return "It.isAny()";
		}
	}
}
