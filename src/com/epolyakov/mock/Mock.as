package com.epolyakov.mock
{
	import flash.utils.Dictionary;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class Mock
	{
		private static var _expectations:Vector.<Expectation> = new <Expectation>[];
		private static var _invocations:Vector.<Invocation> = new <Invocation>[];
		private static var _getters:Dictionary = new Dictionary();
		private static var _setters:Dictionary = new Dictionary();

		private static var _isInSetupMode:Boolean;
		private static var _isInVerifyMode:Boolean;

		private static var _currentInvocation:Invocation;
		private static var _currentArguments:ArgumentsMatcher = new ArgumentsMatcher();

		internal static function getInvocations():Vector.<Invocation>
		{
			return _invocations;
		}

		internal static function getExpectations():Vector.<Expectation>
		{
			return _expectations;
		}

		internal static function getCurrentInvocation():Invocation
		{
			return _currentInvocation;
		}

		internal static function getArgumentsMatcher():ArgumentsMatcher
		{
			return _currentArguments;
		}

		public static function clear():void
		{
			_expectations = new <Expectation>[];
			_invocations = new <Invocation>[];
			_getters = new Dictionary();
			_setters = new Dictionary();
			_isInSetupMode = false;
			_isInVerifyMode = false;
			_currentInvocation = null;
			_currentArguments = new ArgumentsMatcher();
		}

		public static function setup():ISetup
		{
			_isInSetupMode = true;
			_isInVerifyMode = false;
			var expectation:Expectation = new Expectation();
			_expectations.unshift(expectation);
			return expectation;
		}

		internal static function setupComplete():void
		{
			_isInSetupMode = false;
			_currentArguments = new ArgumentsMatcher();
			_currentInvocation = null;
		}

		public static function invoke(object:Object, method:Function, ...args):*
		{
			var invocation:Invocation = new Invocation(object, method, args);

			if (_isInSetupMode || _isInVerifyMode)
			{
				_currentInvocation = invocation;
				return undefined;
			}

			_invocations.push(invocation);
			for each (var expectation:Expectation in _expectations)
			{
				if (expectation.match(invocation))
				{
					return expectation.execute(invocation);
				}
			}
			return undefined;
		}

		public static function get(object:Object):*
		{
			var name:QName = Utils.getCurrentGetterName();
			var getter:Function = _getters[name.toString()];
			if (getter == null)
			{
				getter = function ():*
				{
					return null;
				};
				getter["mockMethodName"] = name.localName;
				_getters[name.toString()] = getter;
			}
			invoke(object, getter);
		}

		public static function set(object:Object, value:*):void
		{
			var name:QName = Utils.getCurrentSetterName();
			var setter:Function = _setters[name.toString()];
			if (setter == null)
			{
				setter = function (v:*):void
				{
				};
				setter["mockMethodName"] = name.localName;
				_setters[name.toString()] = setter;
			}
			invoke(object, setter, value);
		}

		public static function verify():IVerify
		{
			_isInSetupMode = false;
			_isInVerifyMode = true;
			return new Verification();
		}

		internal static function verifyComplete():void
		{
			_isInVerifyMode = false;
			_currentArguments = new ArgumentsMatcher();
			_currentInvocation = null;
		}
	}
}
