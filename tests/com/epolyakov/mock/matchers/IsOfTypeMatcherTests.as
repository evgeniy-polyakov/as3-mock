package com.epolyakov.mock.matchers
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Evgeniy Polyakov
	 */
	public class IsOfTypeMatcherTests
	{
		[Test]
		public function match_ShouldReturnTrue():void
		{
			assertTrue(new IsOfTypeMatcher(XML).match(<a/>));
			assertTrue(new IsOfTypeMatcher(DisplayObject).match(new Sprite()));
			assertFalse(new IsOfTypeMatcher(XML).match({}));
			assertFalse(new IsOfTypeMatcher(Sprite).match(new Bitmap()));
		}

		[Test]
		public function match_ManyTypes_ShouldReturnTrue():void
		{
			assertTrue(new IsOfTypeMatcher(EventDispatcher, [IBitmapDrawable]).match(new Sprite()));
			assertFalse(new IsOfTypeMatcher(EventDispatcher, [IBitmapDrawable]).match(new EventDispatcher()));
		}

		[Test]
		public function toString_ShouldReturnName():void
		{
			assertEquals(new IsOfTypeMatcher(Object).toString(), "It.isOfType([class Object])");
			assertEquals(new IsOfTypeMatcher(EventDispatcher, [IBitmapDrawable]).toString(), "It.isOfType([class EventDispatcher],[class IBitmapDrawable])");
		}
	}
}
