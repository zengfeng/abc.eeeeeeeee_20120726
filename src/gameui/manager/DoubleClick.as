package gameui.manager
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class DoubleClick {

		private static var _timer : Timer;

		private static var _count : int = -1;

		private static var _clickEvent : MouseEvent;

		private static var _timerEvent : Boolean = false;

		private static function _click(e : MouseEvent) : void {
			if (_timerEvent) {
				_timerEvent = false;
				return;
			}
			if (_count == 1) {
				_timer.stop();
				var edc : MouseEvent = new MouseEvent(MouseEvent.DOUBLE_CLICK, e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta);
				e.target["dispatchEvent"](edc);
				_count = 0;
			} else {
				_count++;
				_clickEvent = e;
				_timer.start();
			}
			e.stopImmediatePropagation();
		}

		private static function _stopTimer(e : MouseEvent) : void {
			if (_timer.running) {
				_timer.stop();
			}
		}

		private static function _dispatch(e : TimerEvent) : void {
			_timerEvent = true;
			_clickEvent.target["dispatchEvent"](_clickEvent);
			_count = 0;
		}

		public static function add(target : InteractiveObject, delay : int = 200) : void {
			if(_count == -1) {
				_timer = new Timer(delay, 1);
				_clickEvent = null;
				_count = 0;
				_timer.addEventListener(TimerEvent.TIMER, _dispatch);
			} else {
				if(_timer.delay != delay) {
					_timer.delay = delay;
				}
			}
			target.addEventListener(MouseEvent.MOUSE_DOWN, _stopTimer, false, 999);
			target.addEventListener(MouseEvent.CLICK, _click, false, 999);
			target.doubleClickEnabled = false;
		}

		public static function remove(target : InteractiveObject) : void {
			target.removeEventListener(MouseEvent.MOUSE_DOWN, _stopTimer, false);
			target.removeEventListener(MouseEvent.CLICK, _click, false);
		}
	}
}
