package gameui.monitor
{
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.getTimer;


	public class FPSMonitor extends GComponent {
		private var _bitmapData : BitmapData;
		private var _bitmap : Bitmap;
		private var _time : int;
		private var _count : int;

		override protected function create() : void {
			_bitmapData = new BitmapData(_width, _height, true, 0xBF000000);
			_bitmap = new Bitmap(_bitmapData);
			addChild(_bitmap);
		}

		override protected function onShow() : void {
			_time = getTimer();
			_count = 0;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		override protected function onHide() : void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event : Event) : void {
			if (getTimer() - _time > 1000) {
				this._time = getTimer();
				var percent : Number = _count / stage.frameRate;
				var color : uint = 0x009900;
				if (percent < 0.7) {
					color = 0xFF0000;
				} else if (percent < 0.9) {
					color = 0xFFFF00;
				}
				_bitmapData.setPixel(1, 80 - Math.floor(percent * 70), color);
				_bitmapData.scroll(1, 0);
				_count = 0;
			}
			_count++;
		}

		public function FPSMonitor(data : GComponentData) {
			data.scaleMode = ScaleMode.SCALE_NONE;
			data.width = 50;
			data.height = 80;
			super(data);
		}
	}
}
