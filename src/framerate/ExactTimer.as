package framerate
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class ExactTimer extends EventDispatcher
	{
		private var _timer : Timer;

		private var _repeat : int;

		private var _currentCount : int;

		private var _time : int;

		private var _offset : int;

		private var _tick : int;

		private function timerHandler(event : TimerEvent) : void
		{
			var time : int = getTimer();
			var delta : int = time - _time;
			_time = time;
			_offset += delta;
			if (_offset > _tick)
			{
				_offset -= _tick;
				_currentCount++;
				if (_repeat > 0 && _currentCount > _repeat)
				{
					stop();
					return;
				}
				dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			}
		}

		public function ExactTimer(delay : int, tick : int, repeat : int = 0)
		{
			_repeat = repeat;
			_timer = new Timer(delay);
			_tick = tick;
		}

		public function get running() : Boolean
		{
			return _timer.running;
		}

		public function get currentCount() : int
		{
			return _currentCount;
		}

		public function start() : void
		{
			if (_timer.running) return;
			_offset = 0;
			_time = getTimer();
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			_currentCount = 0;
			_timer.reset();
			_timer.start();
		}

		public function stop() : void
		{
			if (!_timer.running) return;
			_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
			_timer.stop();
		}
	}
}
