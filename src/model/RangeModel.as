package  model {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class RangeModel extends EventDispatcher {

		private var _key : Object;

		private var _min : Number;

		private var _max : Number;

		private var _value : Number;

		private var _percent : Number;

		private var _oldPercent : Number;

		private var _zeroPercent : Number;

		private function reset() : void {
			_oldPercent = _percent;
			_percent = (_value - _min) / (_max - _min);
			_zeroPercent = (0 - _min) / (_max - _min);
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function RangeModel(min : Number = 0,max : Number = 100,value : Number = 0) {
			_min = min;
			_max = max;
			_value = value;
			_percent = (_value - _min) / (_max - _min);
			_oldPercent = _percent;
			_zeroPercent = (0 - _min) / (_max - _min);
		}

		public function resetRange(value : Number,min : Number,max : Number) : void {
			_value = value;
			_min = min;
			_max = max;
			reset();
		}

		public function set key(o : Object) : void {
			_key = o;
		}

		public function get key() : Object {
			return _key;
		}

		public function set min(n : Number) : void {
			if(_min == n)return;
			_min = n;
			reset();
		}

		public function get min() : Number {
			return _min;
		}

		public function set max(n : Number) : void {
			if(_max == n)return;
			_max = n;
			reset();
		}

		public function get max() : Number {
			return _max;
		}

		public function set value(n : Number) : void {
			n = Math.max(_min, Math.min(_max, n));
			if(_value == n)return;
			_value = n;
			reset();
		}

		public function get value() : Number {
			return _value;
		}

		public function get percent() : Number {
			return _percent;
		}

		public function get oldPercent() : Number {
			return _oldPercent;
		}

		public function get zeroPercenr() : Number {
			return _zeroPercent;
		}
	}
}