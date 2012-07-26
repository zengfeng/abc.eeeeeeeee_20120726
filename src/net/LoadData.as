package net {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	
	public class LoadData extends EventDispatcher {

		private var _bytesLoaded : uint;

		private var _bytesTotal : uint;

		private var _startTime : int;

		private var _percent : int;

		public function LoadData() {
		}

		public function reset() : void {
			_percent = 0;
			_startTime = getTimer();
		}

		public function get bytes() : String {
			return int(_bytesLoaded / 1024) + "KB/" + int(_bytesTotal / 1024) + "KB";
		}

		public function get speed() : int {
			return _bytesLoaded / 1024 / (getTimer() - _startTime) * 1000;
		}

		public function calc(bytesLoaded : uint,bytesTotal : uint) : void {
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
			var percent : int = 100 * (_bytesLoaded / _bytesTotal);
			_percent = percent;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function isComplete():Boolean
		{
			return _bytesLoaded>=_bytesTotal;
		}

		public function get percent() : int {
			return _percent;
		}
	}
}
