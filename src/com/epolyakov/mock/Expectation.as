package com.epolyakov.mock
{
	/**
	 * @author Evgeniy Polyakov
	 */
	internal class Expectation implements ISetup, ISetupActions
	{
		private var _object:Object;
		private var _method:Function;
		private var _argumentsMatcher:ArgumentsMatcher;
		private var _returns:* = undefined;
		private var _throws:* = undefined;

		internal function get object():Object
		{
			return _object;
		}

		internal function get method():Function
		{
			return _method;
		}

		internal function get argumentsMatcher():ArgumentsMatcher
		{
			return _argumentsMatcher;
		}

		internal function match(invocation:Invocation):Boolean
		{
			return _object == invocation.object &&
					_method == invocation.method &&
					_argumentsMatcher &&
					_argumentsMatcher.match(invocation.arguments);
		}

		internal function execute(invocation:Invocation):*
		{
			if (_returns is Function)
			{
				if ((_returns as Function).length == 0)
				{
					return (_returns as Function).call(invocation.object);
				}
				return (_returns as Function).apply(invocation.object, invocation.arguments);
			}
			if (_returns !== undefined)
			{
				return _returns;
			}
			if (_throws is Function)
			{
				if ((_throws as Function).length == 0)
				{
					throw (_throws as Function).call(invocation.object);
				}
				throw (_throws as Function).apply(invocation.object, invocation.arguments);
			}
			if (_throws !== undefined)
			{
				throw _throws;
			}
			return undefined;
		}

		public function that(methodCall:*):ISetupActions
		{
			var invocation:Invocation = Mock.getCurrentInvocation();
			var argumentsMatcher:ArgumentsMatcher = Mock.getArgumentsMatcher();
			Mock.setupComplete();

			if (invocation == null)
			{
				throw new MockSetupError("No invocation to setup.");
			}
			if (argumentsMatcher == null)
			{
				argumentsMatcher = new ArgumentsMatcher();
			}
			argumentsMatcher.passArguments(invocation.arguments);

			_object = invocation.object;
			_method = invocation.method;
			_argumentsMatcher = argumentsMatcher;

			return this;
		}

		public function returns(value:*):void
		{
			if (value is Function &&
					(value as Function).length > 0 &&
					_argumentsMatcher &&
					(value as Function).length != _argumentsMatcher.length)
			{
				throw new MockSetupError("Arguments mismatch:" +
						" expected " + (_argumentsMatcher.toString() || "none") +
						" but got " + (value as Function).length);
			}
			_throws = undefined;
			_returns = value;
		}

		public function throws(value:*):void
		{
			if (value is Function &&
					(value as Function).length > 0 &&
					_argumentsMatcher &&
					(value as Function).length != _argumentsMatcher.length)
			{
				throw new MockSetupError("Arguments mismatch:" +
						" expected " + (_argumentsMatcher.toString() || "none") +
						" but got " + (value as Function).length);
			}
			_throws = value;
			_returns = undefined;
		}
	}
}
