package framerate
{
	import gameui.manager.UIManager;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class FrameTimer
	{
		private static var _list : Vector.<IFrame> = new Vector.<IFrame>();
		
		private static var _time : uint;
		
		public  static const  FRAMETIME:Number=13;
		
		private static function onEnterFrane(event : Event) : void
		{
			_time = getTimer();
			for each (var frame:IFrame in _list)
			{
				if(getTimer()-_time>FRAMETIME)return;
				frame.action(_time);
			}
		}
		
		private static var _index : int;

		public static function add(frame : IFrame) : void
		{
			if(!frame)return;
			_index = _list.indexOf(frame);
			if (_index == -1)
			{
				if (_list.length <= 0) (!UIManager.root?frame as DisplayObject:UIManager.root).addEventListener(Event.ENTER_FRAME,onEnterFrane);
				_list.push(frame);
			}
		}

		public static function remove(frame : IFrame) : void
		{
			_index = _list.indexOf(frame);
			if (_index == -1)
				return;
			_list.splice(_index,1);
			if (_list.length <= 0)(!UIManager.root?frame as DisplayObject:UIManager.root).removeEventListener(Event.ENTER_FRAME,onEnterFrane);
		}

		public static function get size() : int
		{
			return _list.length;
		}
	}
}
