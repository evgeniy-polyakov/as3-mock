package com.epolyakov.mock.matchers
{
	import com.epolyakov.mock.IMatcher;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class NotEqualMatcher extends MultiMatcher implements IMatcher
	{
		public function NotEqualMatcher(value:*, values:Array = null)
		{
			super("It.notEqual", value, values);
		}

		public function match(value:*):Boolean
		{
			for each(var v:* in _values)
			{
				if (v == value || (v is Number && isNaN(v) && value is Number && isNaN(value)))
				{
					return false;
				}
			}
			return true;
		}

		override public function toString():String
		{
			if (_values.length == 1)
			{
				if (_values[0] === null)
				{
					return "It.notNull()";
				}
			}
			return super.toString();
		}
	}
}
