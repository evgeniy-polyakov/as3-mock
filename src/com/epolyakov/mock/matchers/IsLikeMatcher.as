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
			return matchRecursive(_value, value);
		}

		public function toString():String
		{
			return "It.isLike(" + Utils.toString(_value) + ")";
		}

		private static function matchRecursive(a:*, b:*):Boolean
		{
			if (a == b || (a is Number && isNaN(a) && b is Number && isNaN(b)))
			{
				return true;
			}
			if (a is Number || a is Boolean || a is String || a is XML || a is XMLList || a is Class ||
					b is Number || b is Boolean || b is String || b is XML || b is XMLList || b is Class)
			{
				return false;
			}
			if (a != null && b != null)
			{
				try
				{
					var prop:String;
					for (prop in a)
					{
						if (!matchRecursive(a[prop], b[prop]))
						{
							return false;
						}
					}
					for (prop in b)
					{
						if (!matchRecursive(b[prop], a[prop]))
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
	}
}
