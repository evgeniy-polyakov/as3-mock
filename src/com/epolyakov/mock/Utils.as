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

		public static function toString(value:*):String
		{
			if (value === undefined)
			{
				return "undefined";
			}
			if (value === null)
			{
				return "null";
			}
			if (value is ByteArray)
			{
				return "[object " + objectToClassName(value) + "]";
			}
			if (value is XML || value is XMLList)
			{
				return value.toXMLString();
			}
			if (isArray(value))
			{
				var s:String = "";
				for each (var v:* in value)
				{
					s += toString(v) + ",";
				}
				return s.slice(0, -1);
			}
			return value.toString();
		}

		private static function isArray(value:*):Boolean
		{
			return value is Array || describeType(value).@name.toXMLString().indexOf("__AS3__.vec::Vector") == 0;
		}
	}
}
