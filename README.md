# as3-mock
Simple mocking for AS3 unit tests.

## About
1. Mock objects are calling their methods directly, no string identifiers are used. That allows to update tests automatically when mocked methods are renamed. So your tests will be always consistent.
2. Generating of classes is not supported because flash player does not provide it out of the box. 
This approach has some advantages:
    - You always have full control over your mock objects. The code you write is executed, there is no hidden or unexpected behavior.
    - Custom test runner is not required. You can start to use mocking directly in your tests.
    - No magic with bytecode, no additional classes are loaded into application domain.
3. Minimalistic API and strictly defined workflow: create mock class once for all tests, then in each test method setup behavior of mock object, call the tested method, verify that certain methods of mock object have been called.

## Getting started
### Create mock class
Since the library does not support generating of classes you should define them manually. This should be done only once for all tests.
Extending a class:
```actionscript
public class MyMock extends SomeClass {
  override public function someMethod(arg1:Boolean, arg2:String):int {
    return Mock.invoke(this, someMethod, arg1, arg2);
  }
}
```
Or implementing an interface:
```actionscript
public class MyMock implements SomeInterface {
  public function someMethod(arg1:Boolean, arg2:String):int {
    return Mock.invoke(this, someMethod, arg1, arg2);
  }
}
```
Or simultaneously extending a class and implementing many interfaces. The only thing is required: your mocked method should call `Mock.invoke(this, method, ...arguments)` and return if needed.

### Setup behavior of mock object
In your test method your should define how the mock object will behave. 
Instruct the mocked method to return `1` when it's called with parameters `false, "test"` or throw an exception when it's called with parameters `true, *`:
```actionscript
[Test]
public function test():void {
  var myMock:MyMock = new MyMock();
  Mock.setup.that(myMock.someMethod(true, "test")).returns(1);
  Mock.setup.that(myMock.someMethod(false, It.isAny())).throws(new ArgumentError());
  ...
```

### Call tested method
At this step you should call your tested method which calls `myMock.someMethod`, so you can be sure that tested method behaves correctly. For example it could be done that way:
```actionscript
testedObject.testedMethod(myMock);
```

### Verify mock object
This is the optional step where you can verify that tested method calls correct methods of mock object with correct parameters. If not an `MockVerifyError` will be thrown and test fails.
```actionscript
Mock.verify.that(myMock.someMethod(false, "test"));
```

### Clear invocations
All invocations of mocked methods are stored in a static variable, that should be cleared before or after the test to make sure it can not affect on other tests.
```actionscript
[Before]
public function before():void {
  Mock.clear();
}
```
