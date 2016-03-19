package com.epolyakov.mock
{
	/**
	 * @author Evgeniy Polyakov
	 */
	public class MockSetupError extends Error
	{
		public function MockSetupError(message:String)
		{
			super("MockSetupError: " + message);
		}
	}
}
