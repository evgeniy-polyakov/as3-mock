package com.epolyakov.mock
{
	/**
	 * @author Evgeniy Polyakov
	 */
	public class MockVerifyError extends Error
	{
		public function MockVerifyError(message:String)
		{
			super("MockVerifyError: " + message);
		}
	}
}
