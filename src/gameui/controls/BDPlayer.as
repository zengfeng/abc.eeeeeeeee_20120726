package gameui.controls {
	import bd.BDData;
	import bd.BDUnit;

	import core.IDispose;

	import framerate.FrameTimer;
	import framerate.IFrame;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * BD Player
	 */
	public class BDPlayer extends GComponent implements IDispose ,IFrame {
		private var _bitmap : Bitmap;
		private var _data : BDData;
		private var _frame : int;
		private var _frames : Array;
		private var _index : int;
		private var _count : int;
		private var _loop : int;
		private var _delay : int;
		private var _fun : Function = null;
		private var _onCompleteParams : Array = null;
		private var _isRun : Boolean = false;
		private var _isPause : Boolean = false;

		override protected function create() : void {
			_bitmap = new Bitmap();
			addChild(_bitmap);
		}

		override protected function onHide() : void {
			super.onHide();
			stop();
			_isPause = true;
		}

		override protected function onShow() : void {
			super.onShow();
			if (_isPause)
				play(_delay, _frames, _loop);
			_isPause = false;
		}

		private function timerHandler() : void {
			if (_index >= _frames.length) {
				_index = 0;
				if (_loop > 0) {
					_count++;
					if (_count == _loop) {
						FrameTimer.remove(this);
						_isRun = false;
						if (_fun != null) _fun.apply(null, _onCompleteParams);
						dispatchEvent(new Event(Event.COMPLETE));
						return;
					}
				}
			}
			goto(_frames[_index]);
			_index++;
		}

		private function goto(frame : int) : void {
			if (frame < 0 || frame >= _data.total) {
				_frame = -1;
				_bitmap.bitmapData = null;
				return;
			}
			if (_frame == frame) return;
			_frame = frame;
			var unit : BDUnit = _data.getBDUnit(_frame);
			_bitmap.x = unit.offset.x;
			_bitmap.y = unit.offset.y;
			_bitmap.bitmapData = unit.bds;
			_bitmap.smoothing = true;
		}

		public function BDPlayer(base : GComponentData) {
			super(base);
			_frame = -1;
		}

		private var _isDispose : Boolean = false;

		public function dispose() : void {
			stop();
			_frames = null;
			_isDispose = true;
			if (_data) {
				_data.removePlay(this);
				_data.dispose();
			}
		}

		public function get isDispose() : Boolean {
			return _isDispose;
		}

		public function setBDData(data : BDData) : void {
			_data = data;
			_frame = -1;
			_bitmap.bitmapData = null;
			_isDispose = false;
			if (_data) {
				_data.addPlay(this);
			}
		}

		public function getBitMap() : Bitmap {
			return _bitmap;
		}

		/**
		 * play bds
		 * 
		 * @delay int default=80(0.08s)
		 * @frames Array
		 * @loop int 0 n
		 */
		public function play(delay : int = 80, frames : Array = null, loop : int = 1, index : int = -1, nextFun : Function = null, onCompleteParams : Array = null) : void {
			if (_data == null) {
				return;
			}
			if (index != -1)
				stop();
			_frames = frames;
			if (_frames == null) {
				_frames = new Array();
				for (var i : int = 0;i < _data.total;i++) {
					_frames.push(i);
				}
			}
			if (_frames.length < 2) {
				frame = _frames[0];
			} else {
				_index = index == -1 ? _index : index;
				_count = 0;
				_loop = loop;
				_delay = delay;
				if (_fun != null) _fun.apply(null, _onCompleteParams);
				_fun = nextFun;
				_onCompleteParams = onCompleteParams;
				if (this.stage == null) {
					onHide();
					return;
				}
				if (_isRun) return;
				_isRun = true;
				FrameTimer.add(this);
			}
		}

		public function stop() : void {
			if (!_isRun) return;
			FrameTimer.remove(this);
			_isRun = false;
		}

		public function isRun() : Boolean {
			return _isRun;
		}

		public function get data() : BDData {
			return _data;
		}

		public function set frame(frame : int) : void {
			if (_data == null) return;
			goto(frame);
		}

		public function get frame() : int {
			return _frame;
		}

		public function get total() : int {
			return _data == null ? 0 : _data.total;
		}

		public function set flipH(value : Boolean) : void {
			this.scaleX = value ? -1 : 1;
		}

		public function get hasNext() : Boolean {
			if (!_data) return false;
			return (_frame < _data.total - 1);
		}

		public function next() : void {
			frame = _frame + 1;
		}

		private var lastTime : uint;

		public function action(timer : uint) : void {
			if ((timer - lastTime) >= _delay) {
				timerHandler();
				lastTime = getTimer();
			}
		}

		public function clone() : BDPlayer {
			var data : GComponentData = _base.clone();
			var bds : BDPlayer = new BDPlayer(data);
			bds.moveTo(x, y);
			bds.scaleX = scaleX;
			bds.rotation = rotation;
			bds.setBDData(_data);
			bds.frame = 0;
			return bds;
		}
	}
}