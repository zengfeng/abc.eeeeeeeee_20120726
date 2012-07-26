package gameui.controls {
	import gameui.core.GComponent;
	import gameui.data.GToolTipData;

	import flash.display.Shape;
	import flash.geom.Rectangle;


	/**
	 * Game ToolTip
	 * 
	 */
	public class GToolTip extends GComponent {
		protected var _data : GToolTipData;
		protected var _backgroundSkin : Shape;
		protected var _label : GLabel;

		override protected function create() : void {
			_backgroundSkin = createToolTipBg();
			addChild(_backgroundSkin);
			_label = new GLabel(_data.labelData);
			_label.x = _label.y = _data.padding;
			addChild(_label);
		}

		private static function createToolTipBg() : Shape {
			var tipsBG:Shape = new Shape();
			tipsBG.graphics.beginFill(0x8c6543);//0x7b5432
			tipsBG.graphics.drawRoundRect(0,0,60,28,6,6);
			tipsBG.graphics.beginFill(0x111111);
			tipsBG.graphics.drawRoundRect(1,1,58,26,6,6);
			tipsBG.graphics.endFill();
			tipsBG.scale9Grid = new Rectangle(10,10,40,8);
			tipsBG.alpha = 1;
			return tipsBG;
		}

		override protected function layout() : void {
			_width = _label.width + _data.padding * 2;
			_height = _label.height + _data.padding * 2;
			_backgroundSkin.width = _width;
			_backgroundSkin.height = _height;
		}

		public function GToolTip(data : GToolTipData) {
			_data = data;
			super(data);
			mouseEnabled = mouseChildren = false;
		}

		public function get data() : GToolTipData {
			return _data;
		}

		public function get text() : String {
			return _label.text;
		}

		override public function set source(value : *) : void {
			if (value == null) {
				_label.clear();
			} else {
				_label.htmlText = String(value);
				layout();
			}
			_source = value;
		}
	}
}