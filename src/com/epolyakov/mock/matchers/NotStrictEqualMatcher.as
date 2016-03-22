package com.epolyakov.mock.matchers
{
	import com.epolyakov.mock.IMatcher;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class NotStrictEqualMatcher extends MultiMatcher implements IMatcher
	{
		public function NotStrictEqualMatcher(value:*, values:Array = null)
		{
			super("It.notStrictEqual", value, values);
		}

		public function match(value:*):Boolean
		{
			for each(var v:* in _values)
			{
				if (v === value)
				{
					return false;
				}
			}
			return true;
		}
	}
}
