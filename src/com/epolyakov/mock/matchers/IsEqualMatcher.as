package com.epolyakov.mock.matchers
{
	import com.epolyakov.mock.IMatcher;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsEqualMatcher extends MultiMatcher implements IMatcher
	{
		public function IsEqualMatcher(value:*, values:Array = null)
		{
			super("It.isEqual", value, values);
		}

		public function match(value:*):Boolean
		{
			for each(var v:* in _values)
			{
				if (v == value || (v is Number && isNaN(v) && value is Number && isNaN(value)))
				{
					return true;
				}
			}
			return false;
		}

		override public function toString():String
		{
			if (_values.length == 1)
			{
				var value:* = _values[0];
				if (value === null)
				{
					return "It.isNull()";
				}
				if (value === true)
				{
					return "It.isTrue()";
				}
				if (value === false)
				{
					return "It.isFalse()";
				}
			}
			return super.toString();
		}
	}
}
