package com.epolyakov.mock
{
	/**
	 * @author Evgeniy Polyakov
	 */
	public class MockObject1
	{
		public function testMethod(arg1:int, arg2:String, arg3:Boolean, arg4:Object):void
		{
		}

		public function testMethodNoArgs():void
		{
		}

		public function testMethodVarArgs(...args):void
		{
		}

		public function get property():int
		{
			return Mock.get(this);
		}

		public function set property(value:int):void
		{
			Mock.set(this, value);
		}

		public function get property1():int
		{
			return Mock.get(this);
		}

		public function set property1(value:int):void
		{
			Mock.set(this, value);
		}
	}
}
