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
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(10, result);
		}

		[Test]
		public function invoke_ArgumentValues_ShouldExecuteFirstMatchedExpectation1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "b", true, obj)).returns(10);
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(1, result);
		}

		[Test]
		public function invoke_ArgumentValues_ShouldExecuteFirstMatchedExpectation2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "b", true, obj)).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "b", true, obj)).returns(10);
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(undefined, result);
		}

		[Test]
		public function invoke_ArgumentMatchers_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), It.isAny(), It.isAny())).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isEqual(1), It.isEqual("a"), It.isTrue(), It.isEqual(obj))).returns(10);
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(10, result);
		}

		[Test]
		public function invoke_ArgumentMatchers_ShouldExecuteFirstMatchedExpectation1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), It.isAny(), It.isAny())).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isEqual(1), It.isEqual("b"), It.isTrue(), It.isEqual(obj))).returns(10);
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(1, result);
		}

		[Test]
		public function invoke_ArgumentMatchers_ShouldExecuteFirstMatchedExpectation2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), It.isAny(), It.isNull())).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isEqual(1), It.isEqual("b"), It.isTrue(), It.isEqual(obj))).returns(10);
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(undefined, result);
		}

		[Test]
		public function invoke_ArgumentValuesAndMatchers_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), true, obj)).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", It.isTrue(), It.isEqual(obj))).returns(10);
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(10, result);
		}

		[Test]
		public function invoke_ArgumentValuesAndMatchers_ShouldExecuteFirstMatchedExpectation1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), true, obj)).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "b", It.isTrue(), It.isEqual(obj))).returns(10);
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(1, result);
		}

		[Test]
		public function invoke_ArgumentValuesAndMatchers_ShouldExecuteFirstMatchedExpectation2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, It.isAny(), It.isAny(), true, {})).returns(1);
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", It.isFalse(), It.isEqual(obj))).returns(10);
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(undefined, result);
		}

		[Test]
		public function invoke_ReturnCallbackNoArgs_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).returns(function ():int
			{
				return 10;
			});
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals(10, result);
		}

		[Test]
		public function invoke_ReturnCallbackWithArgs_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).returns(function (i:int, s:String, b:Boolean, o:Object):String
			{
				return i + s + b + o;
			});
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			assertEquals("1atrue[object Object]", result);
		}

		[Test]
		public function invoke_ReturnCallbackVarArgs_ShouldExecuteFirstMatchedExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethodVarArgs, 1, "a", true, obj)).returns(function (i:int, s:String, b:Boolean, o:Object):String
			{
				return i + s + b + o;
			});
			var result:* = Mock.invoke(mock, mock.testMethodVarArgs, 1, "a", true, obj);

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

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).throws(function ():Error
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

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).throws(function (i:int, s:String, b:Boolean, o:Object):Error
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

			Mock.setup().that(Mock.invoke(mock, mock.testMethodVarArgs, 1, "a", true, obj)).throws(function (i:int, s:String, b:Boolean, o:Object):Error
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

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function setupThatReturns_ArgumentsMismatch_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethodVarArgs, 1, "a", true, obj)).throws(function (i:int, s:String, b:Boolean):void
			{
			});
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function setupThatThrows_ArgumentsMismatch_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethodVarArgs, 1, "a", true, obj)).throws(function (i:int, s:String, b:Boolean):void
			{
			});
		}

		[Test]
		public function setup_ShouldAddExpectationInReverseOrder():void
		{
			var expectation1:ISetup = Mock.setup();
			var expectation2:ISetup = Mock.setup();
			var expectation3:ISetup = Mock.setup();

			assertEquals(3, Mock.getExpectations().length);
			assertEquals(expectation3, Mock.getExpectations()[0]);
			assertEquals(expectation2, Mock.getExpectations()[1]);
			assertEquals(expectation1, Mock.getExpectations()[2]);
		}

		[Test]
		public function setupThat_NoArguments_ShouldConfigureExpectation():void
		{
			var mock:MockObject = new MockObject();
			var expectation:Expectation = Mock.setup() as Expectation;
			expectation.that(Mock.invoke(mock, mock.testMethodNoArgs));

			assertEquals(mock, expectation.object);
			assertEquals(mock.testMethodNoArgs, expectation.method);
			assertEquals(0, expectation.argumentsMatcher.length);
		}

		[Test]
		public function setupThat_ArgumentValues_ShouldConfigureExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			var expectation:Expectation = Mock.setup() as Expectation;
			expectation.that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj));

			assertEquals(mock, expectation.object);
			assertEquals(mock.testMethod, expectation.method);
			assertEquals(4, expectation.argumentsMatcher.length);
			assertEquals("It.isEqual(1),It.isEqual(a),It.isTrue(),It.isEqual([object Object])", expectation.argumentsMatcher.toString());
		}

		[Test]
		public function setupThat_ArgumentMatchers_ShouldConfigureExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			var expectation:Expectation = Mock.setup() as Expectation;
			expectation.that(Mock.invoke(mock, mock.testMethod, It.isEqual(1), It.isOfType(String), It.isTrue(), It.isEqual(obj)));

			assertEquals(mock, expectation.object);
			assertEquals(mock.testMethod, expectation.method);
			assertEquals(4, expectation.argumentsMatcher.length);
			assertEquals("It.isEqual(1),It.isOfType([class String]),It.isTrue(),It.isEqual([object Object])", expectation.argumentsMatcher.toString());
		}

		[Test]
		public function setupThat_ArgumentValuesAndMatchers_ShouldConfigureExpectation():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			var expectation:Expectation = Mock.setup() as Expectation;
			expectation.that(Mock.invoke(mock, mock.testMethod, 1, It.isOfType(String), true, It.isEqual(obj)));

			assertEquals(mock, expectation.object);
			assertEquals(mock.testMethod, expectation.method);
			assertEquals(4, expectation.argumentsMatcher.length);
			assertEquals("It.isEqual(1),It.isOfType([class String]),It.isTrue(),It.isEqual([object Object])", expectation.argumentsMatcher.toString());
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function setupThat_ArgumentDefaultNumberAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 0, It.isOfType(String), true, It.isEqual(obj)));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function setupThat_ArgumentNaNAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, NaN, It.isOfType(String), true, It.isEqual(obj)));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function setupThat_ArgumentNullAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, It.isOfType(String), true, null));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function setupThat_ArgumentUndefinedAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, It.isOfType(String), true, undefined));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function setupThat_ArgumentFalseAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, It.isOfType(String), false, It.isEqual(obj)));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function setupThat_NoInvocation_ShouldFail():void
		{
			Mock.setup().that(undefined);
		}

		[Test]
		public function verify_ShouldCreateVerification():void
		{
			var verification:IVerify = Mock.verify();
			assertTrue(verification is Verification);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_Once_ShouldFailIfNoInvocations():void
		{
			var mock:MockObject = new MockObject();
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, null), Times.once);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_Never_ShouldFailIfoOneInvocation():void
		{
			var mock:MockObject = new MockObject();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, null);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, null), Times.never);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_Twice_ShouldFailIfOneInvocation():void
		{
			var mock:MockObject = new MockObject();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, null);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, null), Times.twice);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_Thrice_ShouldFailIfTwoInvocations():void
		{
			var mock:MockObject = new MockObject();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, null);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, null);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, null), Times.thrice);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_1_ShouldFailIfNoInvocations():void
		{
			var mock:MockObject = new MockObject();
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, null), 1);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_0_ShouldFailIfoOneInvocation():void
		{
			var mock:MockObject = new MockObject();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, null);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, null), 0);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_2_ShouldFailIfOneInvocation():void
		{
			var mock:MockObject = new MockObject();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, null);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, null), 2);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_3_ShouldFailIfTwoInvocations():void
		{
			var mock:MockObject = new MockObject();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, null);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, null);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, null), 3);
		}

		[Test]
		public function verifyThat_ArgumentValues_ShouldMatch():void
		{
			var mock:MockObject = new MockObject();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, null);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, null));
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_ArgumentValues_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, {});
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, null));
		}

		[Test]
		public function verifyThat_ArgumentMatchers_ShouldMatch():void
		{
			var mock:MockObject = new MockObject();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, null);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, It.isEqual(1), It.isOfType(String), It.isTrue(), It.isNull()));
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_ArgumentMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			Mock.invoke(mock, mock.testMethod, 1, "a", true, {});
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, It.isEqual(1), It.isOfType(String), It.isTrue(), It.isNull()));
		}

		[Test]
		public function setupThat_ArgumentValuesAndMatchers_ShouldMatch():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, It.isOfType(String), true, It.isEqual(obj)));
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function setupThat_ArgumentValuesAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.invoke(mock, mock.testMethod, 1, "a", false, obj);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, It.isOfType(String), true, It.isEqual(obj)));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function verifyThat_ArgumentDefaultNumberAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 0, It.isOfType(String), true, It.isEqual(obj)));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function verifyThat_ArgumentNaNAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, NaN, It.isOfType(String), true, It.isEqual(obj)));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function verifyThat_ArgumentNullAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, It.isOfType(String), true, null));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function verifyThat_ArgumentUndefinedAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, It.isOfType(String), true, undefined));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function verifyThat_ArgumentFalseAndMatchers_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, It.isOfType(String), false, It.isEqual(obj)));
		}

		[Test(expects="com.epolyakov.mock.MockSetupError")]
		public function verifyThat_NoInvocation_ShouldFail():void
		{
			Mock.verify().that(undefined);
		}

		[Test]
		public function verifyTotal_Number_ShouldVerify():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			Mock.verify().total(3);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyTotal_Number_ShouldFail1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			Mock.verify().total(2);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyTotal_Number_ShouldFail2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			Mock.verify().total(4);
		}

		[Test]
		public function verifyTotal_Times_ShouldVerify():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			Mock.verify().total(Times.thrice);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyTotal_Times_ShouldFail1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			Mock.verify().total(Times.twice);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyTotal_Times_ShouldFail2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			Mock.verify().total(Times.exactly(4));
		}

		[Test]
		public function verifyThatVerifyTotal_ShouldVerify():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			Mock.verify()
					.that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj), 3)
					.verify()
					.total(3);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThatVerifyTotal_ShouldFail1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			Mock.verify()
					.that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj), Times.atLeast(3))
					.verify()
					.total(2);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThatVerifyTotal_ShouldFail2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);

			Mock.verify()
					.that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj), Times.atLeast(3))
					.verify()
					.total(4);
		}

		[Test]
		public function verifyThat_Sequential_ShouldVerify():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 2, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 3, "a", true, obj);

			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj))
					.verify().that(Mock.invoke(mock, mock.testMethod, 2, "a", true, obj))
					.verify().that(Mock.invoke(mock, mock.testMethod, 3, "a", true, obj));
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_Sequential_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 2, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 3, "a", true, obj);

			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj))
					.verify().that(Mock.invoke(mock, mock.testMethod, 3, "a", true, obj))
					.verify().that(Mock.invoke(mock, mock.testMethod, 2, "a", true, obj));
		}

		[Test]
		public function verifyThat_SequentialSkip_ShouldVerify():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 2, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 3, "a", true, obj);

			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj))
					.verify().that(Mock.invoke(mock, mock.testMethod, 3, "a", true, obj));
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_SequentialSkip_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 2, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 3, "a", true, obj);

			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 3, "a", true, obj))
					.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj));
		}

		[Test]
		public function verifyThat_SequentialGreedy_ShouldVerify():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 2, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 3, "a", true, obj);

			Mock.verify().that(Mock.invoke(mock, mock.testMethod, It.isEqual(1, 2), "a", true, obj), Times.twice)
					.verify().that(Mock.invoke(mock, mock.testMethod, 3, "a", true, obj));
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_SequentialGreedy_ShouldFail():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 2, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 3, "a", true, obj);

			Mock.verify().that(Mock.invoke(mock, mock.testMethod, It.isEqual(1, 2, 3), "a", true, obj), Times.thrice)
					.verify().that(Mock.invoke(mock, mock.testMethod, 3, "a", true, obj));
		}

		[Test]
		public function verifyThat_SequentialNever_ShouldVerify():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 2, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 3, "a", true, obj);

			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj))
					.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", false, obj), Times.never)
					.verify().that(Mock.invoke(mock, mock.testMethod, 2, "a", false, obj), Times.never)
					.verify().that(Mock.invoke(mock, mock.testMethod, 2, "a", true, obj))
					.verify().that(Mock.invoke(mock, mock.testMethod, 2, "a", true, null), Times.never)
					.verify().that(Mock.invoke(mock, mock.testMethod, 3, "a", true, null), Times.never)
					.verify().that(Mock.invoke(mock, mock.testMethod, 3, "a", true, obj));
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_SequentialNever_ShouldFail1():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 2, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 3, "a", true, obj);

			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj))
					.verify().that(Mock.invoke(mock, mock.testMethod, 2, "a", true, obj), Times.never)
					.verify().that(Mock.invoke(mock, mock.testMethod, 3, "a", true, obj));
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function verifyThat_SequentialNever_ShouldFail2():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 2, "a", true, obj);
			Mock.invoke(mock, mock.testMethod, 3, "a", true, obj);

			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj))
					.verify().that(Mock.invoke(mock, mock.testMethod, 3, "a", true, obj), Times.never)
					.verify().that(Mock.invoke(mock, mock.testMethod, 2, "a", true, obj));
		}

		[Test]
		public function setupThatVerifyThat_RightInvocation_ShouldWorkTogether():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).returns(1);
			var result:* = Mock.invoke(mock, mock.testMethod, 1, "a", true, obj);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj));
			assertEquals(1, result);
		}

		[Test(expects="com.epolyakov.mock.MockVerifyError")]
		public function setupThatVerifyThat_WrongInvocation_ShouldWorkTogether():void
		{
			var mock:MockObject = new MockObject();
			var obj:Object = {};

			Mock.setup().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj)).returns(1);
			Mock.invoke(mock, mock.testMethod, 1, "a", false, obj);
			Mock.verify().that(Mock.invoke(mock, mock.testMethod, 1, "a", true, obj));
		}

		private function testInvocation(invocation:Invocation, object:Object, method:Function, ...args):void
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
