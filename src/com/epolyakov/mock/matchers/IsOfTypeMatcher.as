package com.epolyakov.mock.matchers
{
	import com.epolyakov.mock.IMatcher;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsOfTypeMatcher extends MultiMatcher implements IMatcher
	{
		public function IsOfTypeMatcher(value:Class, values:Array = null)
		{
			super("It.isOfType", value, values);
		}

		public function match(value:*):Boolean
		{
			for each (var type:Class in _values)
			{
				if (!(value is type))
				{
					return false;
				}
			}
			return true;
		}
	}
}
