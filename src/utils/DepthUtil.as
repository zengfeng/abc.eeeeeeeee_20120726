package  utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class DepthUtil
	{
		/**
		 * Sort DisplayObjects in an Array by "y".
		 * 
		 * @param arr	An Array of DisplayObject.
		 */		
		public static function sortArray(arr:Array):void
		{
			arr.sortOn("y", Array.NUMERIC);
		}
		/**
		 * Sort all children of a DisplayObjectContainer by "y".
		 * 
		 * @param container
		 */		
		public static function sortAll(container:DisplayObjectContainer):void
		{
			var tmpArr:Array = [];
			var count:int = container.numChildren;
			for (var i:int = 0; i < count; i++)
			{
				tmpArr.push(container.getChildAt(i));
			}
			sortArray(tmpArr);
			for each (var item:DisplayObject in tmpArr)
			{
				container.addChild(item);
			}
		}
		/**
		 * Sort a DisplayObject in its container by "y".
		 */
		public static function sortOne(target:DisplayObject):void
		{
			var container:DisplayObjectContainer = target.parent;
			var targetIndex:int = container.getChildIndex(target);
			//
			var testIndex:int;
			var testObject:DisplayObject;
			// 上
			if (targetIndex > 0)
			{
				testIndex = targetIndex - 1;
				testObject = container.getChildAt(testIndex);
				
				if (testObject.y > target.y)
				{
					while (--testIndex >= 0)
					{
						testObject = container.getChildAt(testIndex);
						if (testObject.y < target.y)
						{
							container.setChildIndex(target, testIndex + 1);
							return;
						}
					}
					container.setChildIndex(target, 0);
					return;
				}
				//
			}
			// 下
			if (targetIndex < container.numChildren - 1)
			{
				testIndex = targetIndex + 1;
				testObject = container.getChildAt(testIndex);
				if (testObject.y < target.y)
				{
					while (++testIndex < container.numChildren)
					{
						testObject = container.getChildAt(testIndex);
						if (testObject.y > target.y)
						{
							container.setChildIndex(target, testIndex);
							return;
						}
					}
					container.setChildIndex(target, container.numChildren - 1);
				}
			}
		}
	}
}