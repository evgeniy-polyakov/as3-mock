package com.epolyakov.mock.matchers
{
	import com.epolyakov.mock.IMatcher;
	import com.epolyakov.mock.Utils;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsLikeMatcher implements IMatcher
	{
		private var _value:*;

		public function IsLikeMatcher(value:*)
		{
			_value = value;
		}

		public function match(value:*):Boolean
		{
			if (new IsEqualMatcher(_value).match(value))
			{
				return true;
			}
			if (_value != null && value != null)
			{
				try
				{
					var prop:String;
					for (prop in _value)
					{
						if (_value[prop] != value[prop])
						{
							return false;
						}
					}
					for (prop in value)
					{
						if (value[prop] != _value[prop])
						{
							return false;
						}
					}
				}
				catch (error:RangeError)
				{
					return false;
				}
				return true;
			}
			return false;
		}

		public function toString():String
		{
			return "It.isLike(" + Utils.toString(_value) + ")";
		}
	}
}
