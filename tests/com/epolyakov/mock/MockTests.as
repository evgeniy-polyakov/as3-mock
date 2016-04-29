package com.epolyakov.mock
{
	import flash.errors.EOFError;
	import flash.errors.IOError;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class MockTests
	{
		[Before]
		public function Before():void
		{
			Mock.clear();
		}

		[Test]
		public function invoke_ShouldAddInvocation():void
		{
			var mock:MockObject = new MockObject();
			var mock1:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 0, "b", false, null);
			Mock.invoke(mock1, mock1.testMethod, 1, "a", true, obj);
			Mock.invoke(mock1, mock1.testMethod, 1, "a", true, obj);
			Mock.invoke(mock1, mock1.testMethod, 0, "b", false, null);
			Mock.invoke(mock, mock.testMethodNoArgs);
			Mock.invoke(mock, mock.testMethodVarArgs, 1, "a", true, obj);
			Mock.invoke(null, trace, "a");

			assertEquals(Mock.getInvocations().length, 9);
			testInvocation(Mock.getInvocations()[0], mock, mock.testMethod, 1, "a", true, obj);
			testInvocation(Mock.getInvocations()[1], mock, mock.testMethod, 1, "a", true, obj);
			testInvocation(Mock.getInvocations()[2], mock, mock.testMethod, 0, "b", false, null);
			testInvocation(Mock.getInvocations()[3], mock1, mock1.testMethod, 1, "a", true, obj);
			testInvocation(Mock.getInvocations()[4], mock1, mock1.testMethod, 1, "a", true, obj);
			testInvocation(Mock.getInvocations()[5], mock1, mock1.testMethod, 0, "b", false, null);
			testInvocation(Mock.getInvocations()[6], mock, mock.testMethodNoArgs);
			testInvocation(Mock.getInvocations()[7], mock, mock.testMethodVarArgs, 1, "a", true, obj);
			testInvocation(Mock.getInvocations()[8], null, trace, "a");
		}

		[Test]
		public function invoke_SetupMode_ShouldSetCurrentInvocation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(Mock.getInvocations().length, 0);
			testInvocation(Mock.getCurrentInvocation(), mock, mock.testMethod, 1, "a", true, obj);
		}

		[Test]
		public function invoke_VerifyMode_ShouldSetCurrentInvocation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.verify();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(Mock.getInvocations().length, 0);
			testInvocation(Mock.getCurrentInvocation(), mock, mock.testMethod, 1, "a", true, obj);
		}

		[Test]
		public function invoke_ArgumentValues_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).returns(10);
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(10, result);
		}

		[Test]
		public function invoke_ArgumentValues_ShouldExecuteFirstMatchedExpectation1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "b", true, obj)).returns(10);
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(1, result);
		}

		[Test]
		public function invoke_ArgumentValues_ShouldExecuteFirstMatchedExpectation2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "b", true, obj)).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "b", true, obj)).returns(10);
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(undefined, result);
		}

		[Test]
		public function invoke_ArgumentMatchers_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), It.isAny(), It.isAny())).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isEqual(1), It.isEqual("a"), It.isTrue(), It.isEqual(obj))).returns(10);
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(10, result);
		}

		[Test]
		public function invoke_ArgumentMatchers_ShouldExecuteFirstMatchedExpectation1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), It.isAny(), It.isAny())).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isEqual(1), It.isEqual("b"), It.isTrue(), It.isEqual(obj))).returns(10);
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(1, result);
		}

		[Test]
		public function invoke_ArgumentMatchers_ShouldExecuteFirstMatchedExpectation2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), It.isAny(), It.isNull())).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isEqual(1), It.isEqual("b"), It.isTrue(), It.isEqual(obj))).returns(10);
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(undefined, result);
		}

		[Test]
		public function invoke_ArgumentValuesAndMatchers_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), true, obj)).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", It.isTrue(), It.isEqual(obj))).returns(10);
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(10, result);
		}

		[Test]
		public function invoke_ArgumentValuesAndMatchers_ShouldExecuteFirstMatchedExpectation1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), true, obj)).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "b", It.isTrue(), It.isEqual(obj))).returns(10);
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(1, result);
		}

		[Test]
		public function invoke_ArgumentValuesAndMatchers_ShouldExecuteFirstMatchedExpectation2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), true, {})).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", It.isFalse(), It.isEqual(obj))).returns(10);
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(undefined, result);
		}

		[Test]
		public function invoke_ReturnCallbackNoArgs_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).returns(function ()
			{
				return 10;
			});
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(10, result);
		}

		[Test]
		public function invoke_ReturnCallbackWithArgs_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).returns(function (i:int, s:String, b:Boolean, o:Object)
			{
				return i + s + b + o;
			});
			var result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals("1atrue[object Object]", result);
		}

		[Test]
		public function invoke_ReturnCallbackVarArgs_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethodVarArgs, 1, "a", true, obj)).returns(function (i:int, s:String, b:Boolean, o:Object)
			{
				return i + s + b + o;
			});
			var result = Mock.invoke(mock, mock.testMethodVarArgs, 1, "a", true, obj);

			assertEquals("1atrue[object Object]", result);
		}

		[Test]
		public function invoke_Throws_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			var e1:Error = new EOFError();
			var e2:Error = new IOError();

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).throws(e1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).throws(e2);
			var error:Error;
			var result:*;
			try
			{
				result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			}
			catch (e:Error)
			{
				error = e;
			}
			assertEquals(undefined, result);
			assertEquals(e2, error);
		}

		[Test]
		public function invoke_Throws_ShouldExecuteFirstMatchedExpectation1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			var e1:Error = new EOFError();
			var e2:Error = new IOError();

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).throws(e1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "b", true, obj)).throws(e2);
			var error:Error;
			var result:*;
			try
			{
				result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			}
			catch (e:Error)
			{
				error = e;
			}
			assertEquals(undefined, result);
			assertEquals(e1, error);
		}

		[Test]
		public function invoke_Throws_ShouldExecuteFirstMatchedExpectation2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			var e1:Error = new EOFError();
			var e2:Error = new IOError();

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", false, obj)).throws(e1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "b", true, obj)).throws(e2);
			var isErrorThrown:Boolean = false;
			var result:*;
			try
			{
				result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			}
			catch (e:Error)
			{
				isErrorThrown = true;
			}
			assertEquals(undefined, result);
			assertFalse(isErrorThrown);
		}

		[Test]
		public function invoke_ThrowCallbackNoArgs_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			var err:Error = new IOError();

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).throws(function ()
			{
				return err;
			});
			var error:Error;
			var result:*;
			try
			{
				result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			}
			catch (e:Error)
			{
				error = e;
			}
			assertEquals(undefined, result);
			assertEquals(err, error);
		}

		[Test]
		public function invoke_ThrowCallbackWithArgs_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			var err:Error = new IOError();

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).throws(function (i:int, s:String, b:Boolean, o:Object)
			{
				return new IOError(i + s + b + o);
			});
			var error:Error;
			var result:*;
			try
			{
				result = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			}
			catch (e:Error)
			{
				error = e;
			}
			assertEquals(undefined, result);
			assertTrue(error is IOError);
			assertEquals((error as IOError).message, "1atrue[object Object]");
		}

		[Test]
		public function invoke_ThrowCallbackVarArgs_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			var err:Error = new IOError();

			Mock.setup().that(Mock.invoke(mock, mock.testMethodVarArgs, 1, "a", true, obj)).throws(function (i:int, s:String, b:Boolean, o:Object)
			{
				return new IOError(i + s + b + o);
			});
			var error:Error;
			var result:*;
			try
			{
				result = Mock.invoke(mock, mock.testMethodVarArgs, 1, "a", true, obj);
			}
			catch (e:Error)
			{
				error = e;
			}
			assertEquals(undefined, result);
			assertTrue(error is IOError);
			assertEquals((error as IOError).message, "1atrue[object Object]");
		}

		private function testInvocation(invocation:Invocation, object:Object, method:Function, ...args)
		{
			assertEquals(object, invocation.object);
			assertEquals(method, invocation.method);
			assertEquals(args.length, invocation.arguments.length);
			for (var i:int = 0; i < args.length; i++)
			{
				assertEquals(args[i], invocation.arguments[i]);
			}
		}
	}
}
