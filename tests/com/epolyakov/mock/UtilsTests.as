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

			var f:Function = function ():void
			{
			};
			f["mockMethodName"] = "testMethod";
			assertEquals("testMethod", Utils.functionToMethodName(f, s));
			assertEquals("testMethod", Utils.functionToMethodName(f, null));
		}

		[Test]
		public function toString_ShouldConvertObjectToString():void
		{
			assertEquals("null,[class Class],[object ByteArray],[object Object],0,1,true,false,NaN,undefined,abc",
					Utils.toString([null, Class, new ByteArray(), {}, 0, 1, true, false, NaN, undefined, "abc"]));
			assertEquals("null,[class Class],[object ByteArray],[object Object],0,1,true,false,NaN,null,abc",
					Utils.toString(new <*>[null, Class, new ByteArray(), {}, 0, 1, true, false, NaN, undefined, "abc"]));
			assertEquals("", Utils.toString([]));
			assertEquals("", Utils.toString(new <int>[]));
			assertEquals("null", Utils.toString(null));
			assertEquals("[class Class]", Utils.toString(Class));
			assertEquals("[object ByteArray]", Utils.toString(new ByteArray()));
			assertEquals("[object Object]", Utils.toString({}));
			assertEquals("0", Utils.toString(0));
			assertEquals("1", Utils.toString(1));
			assertEquals("true", Utils.toString(true));
			assertEquals("false", Utils.toString(false));
			assertEquals("NaN", Utils.toString(NaN));
			assertEquals("undefined", Utils.toString(undefined));
			assertEquals("abc", Utils.toString("abc"));
			assertEquals("", Utils.toString(""));
			assertEquals('<x a="b"/>', Utils.toString(<x a="b"/>));
			assertEquals('<a/>\n<b/>', Utils.toString(<x>
					<a/>
					<b/>
					</x>.children()));
		}
	}
}
