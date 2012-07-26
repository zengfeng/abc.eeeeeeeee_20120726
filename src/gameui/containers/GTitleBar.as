package gameui.containers
{
	import gameui.controls.GLabel;
	import gameui.core.GComponent;
	import gameui.core.ScaleMode;
	import gameui.data.GTitleBarData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import log4a.Logger;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class GTitleBar extends GComponent
	{
		protected var _data : GTitleBarData;

		protected var _backgroundSkin : Sprite;

		protected var _label : GLabel;

		protected var _layout : GLayout;

		override protected function create() : void
		{
			_backgroundSkin = UIManager.getUI(_data.backgroundAsset);
			_label = new GLabel(_data.labelData);
			if (_backgroundSkin)
				addChild(_backgroundSkin);
			addChild(_label);
			switch(_data.scaleMode)
			{
				case ScaleMode.SCALE_WIDTH:
					if (_backgroundSkin)
						_height = _backgroundSkin.height;
					break;
				case ScaleMode.SCALE_NONE:
					if (!_backgroundSkin) break;
					_width = _backgroundSkin.width;
					_height = _backgroundSkin.height;
					break;
			}
		}

		override protected function layout() : void
		{
			switch(_data.scaleMode)
			{
				case ScaleMode.SCALE9GRID:
					if (!_backgroundSkin) break;
					_backgroundSkin.width = _width;
					_backgroundSkin.height = _height;
					break;
				case ScaleMode.SCALE_WIDTH:
					if (!_backgroundSkin) break;
					_backgroundSkin.width = _width;
					break;
				case ScaleMode.SCALE_NONE:
					break;
				default:
					Logger.error("scale mode is invalid!");
					break;
			}
			GLayout.layout(_label);
		}

		public function GTitleBar(data : GTitleBarData)
		{
			_data = data;
			super(data);
		}

		public function get backgroundSkin() : *
		{
			return _backgroundSkin;
		}

		public function set backgroundSkin(value : *) : void
		{
			if (value is Bitmap)
			{
				this.removeChildAt(0);
				addChildAt(_backgroundSkin,0);
			}
		}

		public function set text(value : String) : void
		{
			_label.text = value;
			GLayout.layout(_label);
		}

		public function set htmlText(value : String) : void
		{
			_label.htmlText = value;
			GLayout.layout(_label);
		}
	}
}
