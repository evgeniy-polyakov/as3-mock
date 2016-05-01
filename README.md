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
When writing a test you should define how the mock object will behave. Instruct the mocked method to return `1` when it's called with arguments `false, "test"` or throw an exception when it's called with arguments `true, *`:
```actionscript
[Test]
public function test():void {
  var myMock:MyMock = new MyMock();
  Mock.setup().that(myMock.someMethod(false, "test")).returns(1);
  Mock.setup().that(myMock.someMethod(true, It.isAny())).throws(new ArgumentError());
  ...
```

### Call tested method
At this step you should call your tested method which calls `myMock.someMethod`, so you can be sure that the tested method behaves correctly. For example it could be done that way:
```actionscript
testedObject.testedMethod(myMock);
```

### Verify mock object
At this step you verify that the tested method calls correct methods of mock object with correct arguments. If not a `MockVerifyError` will be thrown and test fails.
```actionscript
Mock.verify().that(myMock.someMethod(false, "test"));
```

### Clear invocations
All invocations of mocked methods are stored in a static variable, that should be cleared before or after the test to make sure it can not affect on other tests.
```actionscript
[Before]
public function before():void {
  Mock.clear();
}
```

## Advanced features
### Argument matchers
When setup or verify the mocked method there is an option to use argument matcher instead of exact value of argument:
- `It.isAny()` - the argument can have any value
- `It.isEqual(value:*, ...values)` - the argument is equal (==) to _any_ of the given values
- `It.isStrictEqual(value:*, ...values)` - the argument is stritly equal (===) to _any_ of the given values
- `It.isOfType(type:*, ...types)` - the argument extends or implements _all_ of the given classes or interfaces
- `It.isLike(value:*)` - the argument is checked by `for each` loop recursivelly, it's usefull for arrays, vectors and dynamic objects
- `It.notEqual(value:*, ...values)` - the argument is not equal (==) to _any_ of the given values
- `It.notStrictEqual(value:*, ...values)` - the argument is not strictly equal (===) to _any_ of the given values
- `It.notOfType(type:*, ...types)` - the argument does not extend or implement _any_ of the given classes or interfaces
- `It.notLike(value:*)` - the argument is checked by `for each` loop recursivelly, it's usefull for arrays, vectors and dynamic objects
- `It.isNull()` - the arguemnt is null or undefined, same as `It.isEqual(null)`
- `It.notNull()` - the argument is not null or undefined, same as `It.notEqual(null)`
- `It.isTrue()` - the argument is true, same as `It.isEqual(true)`
- `It.isFalse()` - the argument is false, same as `It.isEqual(false)`
- `It.match(matcher:IMatcher)` - the argument is matched by custom `IMatcher` object
- `It.match(func:Function)` - the argument is matched by `function(value:*):Boolean`
- `It.match(regexp:RegExp)` - the argument is converted to string and tested by the given `RegExp`

> Note that you can not combine `null`, `undefined`, `0`, `NaN`, `false` with matchers in one list of function arguments. Otherwise the library can not detect which argument has a matcher and wich one has a value and `MockSetupError` will be thrown. Incorrect: ~~`myMock.someMethod(false, It.isAny())`~~. Correct:`myMock.someMethod(It.isEqual(false), It.isAny())`.

### Setup callbacks
Setup of mocked method supports callbacks to compute the returned value based on the method arguments. Just specify the function in `returns` and make sure it takes the same parameters as the mocked method.
```actionscript
Mock.setup(myMock.someMethod(It.isAny(), It.isAny())).returns(function (b:Boolean, s:String):int {
    return b ? 0 : 1;
});
```
Callbacks with no parameters and no return value are also supported:
```actionscript
Mock.setup(myMock.someMethod(It.isAny(), It.isAny())).returns(function ():void {
    trace("someMethod is invoked");
});
```
Since functions in `returns` are handled specifically the only way to return a function from the mocked method is using callbacks:
```actionscript
Mock.setup(myMock.getFunction(It.isAny())).returns(function (arg:*):Function {
    return function():void {};
});
```
Similarly you can set a callback in `throws`:
```actionscript
Mock.setup(myMock.someMethod(It.isAny(), It.isAny())).throws(function (b:Boolean, s:String):int {
    return b ? new ArgumentError() : new Error(s);
});
```

### Verifying number of invocations
At verification step you can specify how many times you expect the method to be invoked. By default you verify that the method is called exactly once. Here are other options:
- `Times.never` - the method with the given arguments is never called
- `Times.once` - the method is called once, this is default number of invocations verifyed 
- `Times.twice` - the method is called twice
- `Times.thrice` - the method is called thrice
- `Times.exactly(n)` - the method is called exactly `n` times
- `Times.atLeast(n)` - the method is called `n` times or more
- `Times.atMost(n)` - the method is called `n` times or less
- `Times.between(n,m)` - the method is called between `n` and `m` times inclusive
- `n` - exact number of invocations, same as `Times.exactly(n)`
- `0` - the method is never called, same as `Times.never`

Example:
```actionscript
Mock.verify().that(myMock.someMethod(true, "test"), Times.never);
Mock.verify().that(myMock.someMethod(false, "test"), Times.atLeast(2));
```

### Verifying total number of invocations
Sometimes there is a need to verify total number of all invocations made on all mock objects. For example you are testing that a method is called and would like to be sure that no other methods have been called.
```actionscript
Mock.verify().total(Times.once);
```
You can pass any `Times` or a number into this method.

### Verifying order of execution
All invocations are stored in order of execution and you are able to verify that some method is called before the other. It can be done using chained `verify()` methods:
```actionscript
Mock.verify().that(myMock.someMethod(false, "test"))
    .verify().that(otherMock.otherMethodCalledAfter());
```

> Note that verification is greedy: it starts to search the second method only after the last invocation of the first method with the given arguments. However verifications with `Times.never` are not greedy, you can continue your sequence after that.
