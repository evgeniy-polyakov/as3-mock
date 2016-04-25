package com.epolyakov.mock
{
	import flash.utils.ByteArray;
	import flash.utils.describeType;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class Utils
	{
		public static function objectToClassName(value:Object):String
		{
			if (value != null)
			{
				var qName:String = describeType(value).@name.toXMLString();
				var index:int = qName.indexOf("::");
				if (index >= 0)
				{
					return qName.substring(index + 2);
				}
				return qName;
			}
			return "";
		}

		public static function functionToMethodName(value:Function, scope:Object):String
		{
			if (scope != null)
			{
				var xml:XML = describeType(scope);
				for each (var name:String in xml..method.@name)
				{
					if (scope[name] == value)
					{
						return name;
					}
				}
			}
			if (value != null)
			{
				var x:XML = describeType(value);
				var qName:String = describeType(value).@name.toXMLString();
				var index:int = qName.indexOf("::");
				if (index >= 0)
				{
					return qName.substring(index + 2);
				}
				return qName;
			}
			return "";
		}

		public static function arrayToString(array:Array):String
		{
			if (array == null)
			{
				return "";
			}
			return array.map(function (item:*, ...rest):String
			{
				if (item === undefined)
				{
					return "undefined";
				}
				if (item === null)
				{
					return "null";
				}
				if (item is ByteArray)
				{
					return "[object " + objectToClassName(item) + "]";
				}
				return item.toString();
			}).join(",");
		}
	}
}
