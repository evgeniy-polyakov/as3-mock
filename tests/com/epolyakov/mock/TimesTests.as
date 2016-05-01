package com.epolyakov.mock
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class TimesTests
	{
		[Test]
		public function never_ShouldMatch0():void
		{
			assertTrue(Times.never.match(0));
			assertFalse(Times.never.match(1));
			assertFalse(Times.never.match(2));
		}

		[Test]
		public function once_ShouldMatch1():void
		{
			assertTrue(Times.once.match(1));
			assertFalse(Times.once.match(0));
			assertFalse(Times.once.match(2));
		}

		[Test]
		public function twice_ShouldMatch2():void
		{
			assertTrue(Times.twice.match(2));
			assertFalse(Times.twice.match(0));
			assertFalse(Times.twice.match(1));
			assertFalse(Times.twice.match(3));
		}

		[Test]
		public function thrice_ShouldMatch3():void
		{
			assertTrue(Times.thrice.match(3));
			assertFalse(Times.thrice.match(0));
			assertFalse(Times.thrice.match(1));
			assertFalse(Times.thrice.match(2));
			assertFalse(Times.thrice.match(4));
		}

		[Test]
		public function exactly_ShouldMatchTheGivenValue():void
		{
			assertTrue(Times.exactly(15).match(15));
			assertFalse(Times.exactly(15).match(14));
			assertFalse(Times.exactly(15).match(14));
			assertFalse(Times.exactly(15).match(0));
		}

		[Test]
		public function atLeast_ShouldMatchTheGivenValue():void
		{
			assertTrue(Times.atLeast(4).match(4));
			assertTrue(Times.atLeast(4).match(5));
			assertTrue(Times.atLeast(4).match(6));
			assertFalse(Times.atLeast(4).match(0));
			assertFalse(Times.atLeast(4).match(1));
			assertFalse(Times.atLeast(4).match(2));
			assertFalse(Times.atLeast(4).match(3));
		}

		[Test]
		public function atMost_ShouldMatchTheGivenValue():void
		{
			assertTrue(Times.atMost(4).match(0));
			assertTrue(Times.atMost(4).match(1));
			assertTrue(Times.atMost(4).match(2));
			assertTrue(Times.atMost(4).match(3));
			assertTrue(Times.atMost(4).match(4));
			assertFalse(Times.atMost(4).match(5));
			assertFalse(Times.atMost(4).match(6));
			assertFalse(Times.atMost(4).match(7));
		}

		[Test]
		public function between_ShouldMatchTheGivenValue():void
		{
			assertTrue(Times.between(3, 5).match(3));
			assertTrue(Times.between(3, 5).match(4));
			assertTrue(Times.between(3, 5).match(5));
			assertFalse(Times.between(3, 5).match(0));
			assertFalse(Times.between(3, 5).match(1));
			assertFalse(Times.between(3, 5).match(2));
			assertFalse(Times.between(3, 5).match(6));
			assertFalse(Times.between(3, 5).match(7));
		}

		[Test]
		public function exactly_ShouldTrimWrongValue():void
		{
			assertTrue(Times.exactly(-1).match(0));
			assertFalse(Times.exactly(-1).match(1));
			assertFalse(Times.exactly(-1).match(2));
			assertTrue(Times.exactly(0).match(0));
			assertFalse(Times.exactly(0).match(1));
			assertFalse(Times.exactly(0).match(2));
		}

		[Test]
		public function atLeast_ShouldTrimWrongValue():void
		{
			assertTrue(Times.atLeast(-1).match(0));
			assertTrue(Times.atLeast(-1).match(1));
			assertTrue(Times.atLeast(-1).match(2));
			assertTrue(Times.atLeast(-1).match(3));
			assertTrue(Times.atLeast(0).match(0));
			assertTrue(Times.atLeast(0).match(1));
			assertTrue(Times.atLeast(0).match(2));
			assertTrue(Times.atLeast(0).match(3));
		}

		[Test]
		public function atMost_ShouldTrimWrongValue():void
		{
			assertTrue(Times.atMost(-1).match(0));
			assertFalse(Times.atMost(-1).match(1));
			assertFalse(Times.atMost(-1).match(2));
			assertFalse(Times.atMost(-1).match(3));
			assertTrue(Times.atMost(0).match(0));
			assertFalse(Times.atMost(0).match(1));
			assertFalse(Times.atMost(0).match(2));
			assertFalse(Times.atMost(0).match(3));
		}

		[Test]
		public function between_ShouldTrimWrongValue():void
		{
			assertTrue(Times.between(-1, -1).match(0));
			assertFalse(Times.between(-1, -1).match(1));
			assertFalse(Times.between(-1, -1).match(2));
			assertFalse(Times.between(-1, -1).match(3));

			assertTrue(Times.between(0, 0).match(0));
			assertFalse(Times.between(0, 0).match(1));
			assertFalse(Times.between(0, 0).match(2));
			assertFalse(Times.between(0, 0).match(3));

			assertTrue(Times.between(-1, 0).match(0));
			assertFalse(Times.between(-1, 0).match(1));
			assertFalse(Times.between(-1, 0).match(2));
			assertFalse(Times.between(-1, 0).match(3));

			assertTrue(Times.between(0, -1).match(0));
			assertFalse(Times.between(0, -1).match(1));
			assertFalse(Times.between(0, -1).match(2));
			assertFalse(Times.between(0, -1).match(3));

			assertTrue(Times.between(5, 5).match(5));
			assertFalse(Times.between(5, 5).match(4));
			assertFalse(Times.between(5, 5).match(6));
			assertFalse(Times.between(5, 5).match(0));

			assertTrue(Times.between(5, 2).match(5));
			assertFalse(Times.between(5, 2).match(4));
			assertFalse(Times.between(5, 2).match(6));
			assertFalse(Times.between(5, 2).match(0));
		}

		[Test]
		public function toString_ShouldReturnName():void
		{
			assertEquals("never", Times.never.toString());
			assertEquals("never", Times.exactly(-1).toString());
			assertEquals("never", Times.exactly(0).toString());
			assertEquals("never", Times.between(-1, -1).toString());
			assertEquals("never", Times.between(0, 0).toString());
			assertEquals("never", Times.between(-1, 0).toString());
			assertEquals("never", Times.between(0, -1).toString());

			assertEquals("once", Times.once.toString());
			assertEquals("once", Times.exactly(1).toString());
			assertEquals("once", Times.between(1, 1).toString());

			assertEquals("2 times", Times.twice.toString());
			assertEquals("2 times", Times.exactly(2).toString());
			assertEquals("2 times", Times.between(2, 2).toString());

			assertEquals("3 times", Times.thrice.toString());
			assertEquals("3 times", Times.exactly(3).toString());
			assertEquals("3 times", Times.between(3, 3).toString());

			assertEquals("4 times", Times.exactly(4).toString());
			assertEquals("4 times", Times.between(4, 4).toString());

			assertEquals("from 1 to 4 times", Times.between(1, 4).toString());
			assertEquals("at most 4 times", Times.between(0, 4).toString());
			assertEquals("at most 4 times", Times.between(-1, 4).toString());
			assertEquals("from 3 to 4 times", Times.between(3, 4).toString());

			assertEquals("at least never", Times.atLeast(-1).toString());
			assertEquals("at least never", Times.atLeast(0).toString());
			assertEquals("at least once", Times.atLeast(1).toString());
			assertEquals("at least 2 times", Times.atLeast(2).toString());
			assertEquals("at least 3 times", Times.atLeast(3).toString());
			assertEquals("at least 4 times", Times.atLeast(4).toString());

			assertEquals("never", Times.atMost(-1).toString());
			assertEquals("never", Times.atMost(0).toString());
			assertEquals("at most once", Times.atMost(1).toString());
			assertEquals("at most 2 times", Times.atMost(2).toString());
			assertEquals("at most 3 times", Times.atMost(3).toString());
			assertEquals("at most 4 times", Times.atMost(4).toString());
		}
	}
}
