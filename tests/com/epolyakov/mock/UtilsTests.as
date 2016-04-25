package com.epolyakov.mock
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	import org.flexunit.asserts.assertEquals;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class UtilsTests
	{
		[Test]
		public function objectToClassName_ShouldReturnClassName():void
		{
			assertEquals("Object", Utils.objectToClassName({}));
			assertEquals("Object", Utils.objectToClassName(Object));
			assertEquals("Sprite", Utils.objectToClassName(new Sprite()));
			assertEquals("Sprite", Utils.objectToClassName(Sprite));
			assertEquals("", Utils.objectToClassName(null));
		}

		[Test]
		public function functionToMethodName_ShouldReturnMethodName():void
		{
			var s:Sprite = new Sprite();

			assertEquals("addChild", Utils.functionToMethodName(s.addChild, s));
			assertEquals("removeChild", Utils.functionToMethodName(s.removeChild, s));

			assertEquals("MethodClosure", Utils.functionToMethodName(new Sprite().addChild, s));
			assertEquals("MethodClosure", Utils.functionToMethodName(new Sprite().removeChild, s));

			assertEquals("MethodClosure", Utils.functionToMethodName(new EventDispatcher().addEventListener, s));
			assertEquals("MethodClosure", Utils.functionToMethodName(new EventDispatcher().removeEventListener, s));

			assertEquals("MethodClosure", Utils.functionToMethodName(new EventDispatcher().addEventListener, null));
			assertEquals("MethodClosure", Utils.functionToMethodName(new EventDispatcher().removeEventListener, null));

			assertEquals("MethodClosure", Utils.functionToMethodName(trace, null));
			assertEquals("Function", Utils.functionToMethodName(function ():void {}, null));
			assertEquals("", Utils.functionToMethodName(null, null));
		}

		[Test]
		public function arrayToString_ShouldReturnCommaSeparatedValues():void
		{
			assertEquals("null,[class Class],[object ByteArray],[object Object],0,1,true,false,NaN,undefined,abc",
					Utils.arrayToString([null, Class, new ByteArray(), {}, 0, 1, true, false, NaN, undefined, "abc"]));
			assertEquals("", Utils.arrayToString([]));
			assertEquals("", Utils.arrayToString(null));
		}
	}
}
