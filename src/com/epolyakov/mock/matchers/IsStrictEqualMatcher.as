package com.epolyakov.mock.matchers
{
	import com.epolyakov.mock.IMatcher;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsStrictEqualMatcher extends MultiMatcher implements IMatcher
	{
		public function IsStrictEqualMatcher(value:*, values:Array = null)
		{
			super("It.isStrictEqual", value, values);
		}

		public function match(value:*):Boolean
		{
			for each(var v:* in _values)
			{
				if (v === value)
				{
					return true;
				}
			}
			return false;
		}
	}
}
