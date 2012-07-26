package key {
	import log4a.Logger;
	public class KeyData {

		public static const KEY_DOWN : int = 0;

		public static const KEY_UP : int = 1;

		public static const DOWN_UP : int = 0;

		public static const ONLY_DOWN : int = 1;

		private var _active : Boolean;

		private var _mode : int;

		private var _state : int;

		private var _keyCode : uint;

		private var _callback : Function;

		public function KeyData(keyCode : uint,callback : Function,mode : int) {
			_keyCode = keyCode;
			_callback = callback;
			_mode = mode;
			_active = true;
			_state = KEY_UP;
		}

		public function reset() : void {
			_state = KEY_UP;
		}

		public function set active(value : Boolean) : void {
			if(_active == value)return;
			_active = value;
			reset();
		}

		public function get active() : Boolean {
			return _active;
		}

		public function get isKeyDown() : Boolean {
			return _state == KEY_DOWN;
		}

		public function get keyCode() : uint {
			return _keyCode;
		}

		public function onKeyDown() : void {
			if(_mode == DOWN_UP && _state == KEY_DOWN)return;
			_state = KEY_DOWN;
			try {
				_callback.apply(null, [this]);
			}catch(e : Error) {
				Logger.error(e.message);
			}
		}

		public function onKeyUp() : void {
			if(_state != KEY_DOWN)return;
			_state = KEY_UP;
			if(_mode == ONLY_DOWN)return;
			try {
				_callback.apply(null, [this]);
			}catch(e : Error) {
				Logger.error(e.message);
			}
		}
	}
}
