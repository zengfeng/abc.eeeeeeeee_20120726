package gameui.controls
{
	import gameui.core.GComponent;
	import gameui.data.GProgressBarData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;
	import gameui.skin.PolledSkin;

	import utils.MathUtil;

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Game Progress Bar
	 * 
	 */
	public class GProgressBar extends GComponent
	{
		protected var _data : GProgressBarData;
		protected var _trackSkin : Sprite;
		protected var _barSkin : Sprite;
		protected var _highLightSkin : Sprite;
		protected var _polledSkin : PolledSkin;
		protected var _label : GLabel;
		protected var _value : int = 0;
		protected var _max : int = 100;
		protected var _mode : int;
		protected var _modalSkin : Sprite;

		override protected function create() : void
		{
			_trackSkin = UIManager.getUI(_data.trackAsset);
			_barSkin = UIManager.getUI(_data.barAsset);
			_barSkin.x = _data.paddingX;
			_barSkin.y = _data.paddingY;
			_polledSkin = new PolledSkin();
			_data.labelData.parent = this;
			_label = new GLabel(_data.labelData);
			_mode = _data.mode;
			_value = _data.value;
			_max = _data.max;
			addChild(_trackSkin);
			switch(_mode)
			{
				case GProgressBarData.MANUAL:
					addChild(_barSkin);
					break;
				case GProgressBarData.POLLED:
					addChild(_polledSkin);
					break;
			}
			if (_data.highLightAsset != null)
			{
				_highLightSkin = UIManager.getUI(_data.highLightAsset);
				_highLightSkin.x = _data.padding;
				_highLightSkin.y = _data.padding;
				addChild(_highLightSkin);
			}
			// addChild(_label);
			if (_data.modal)
			{
				_modalSkin = ASSkin.modalSkin;
			}
		}

		override protected function layout() : void
		{
			_trackSkin.width = _width;
			_trackSkin.height = _height;
			if (!_data.barMask)
			{
				_barSkin.width = _width - _data.padding * 2;
				_barSkin.height = _height - _data.padding * 2;
			}
			else
			{
				_barSkin.scrollRect = new Rectangle(0, 0, _width - _data.padding * 2, _height - _data.padding * 2);
			}
			_polledSkin.setSize(_width, _height);
			if (_highLightSkin != null)
			{
				_highLightSkin.width = _width - _data.padding * 2;
				_highLightSkin.height = _height - _data.padding * 2;
			}
			GLayout.layout(_label);
			reset();
		}

		override protected function onShow() : void
		{
			super.onShow();
			if (_data.modal)
			{
				var topLeft : Point = parent.localToGlobal(MathUtil.ORIGIN);
				_modalSkin.x = -topLeft.x;
				_modalSkin.y = -topLeft.y;
				_modalSkin.width = UIManager.stage.stageWidth;
				_modalSkin.height = UIManager.stage.stageHeight;
				parent.addChildAt(_modalSkin, parent.numChildren - 1);
				parent.swapChildrenAt(parent.getChildIndex(this), parent.numChildren - 1);
			}
		}

		override protected function onHide() : void
		{
			super.onHide();
			if (_data.modal)
			{
				_modalSkin.parent.removeChild(_modalSkin);
			}
		}

		protected function reset() : void
		{
			var w : int = Math.round(_value / _max * (_width - _data.paddingX * 2));
			if (!_data.barMask)
			{
				_barSkin.width = w;
			}
			else
			{
				_barSkin.scrollRect = new Rectangle(0, 0, w, _height - _data.paddingY * 2);
			}
		}

		public function GProgressBar(data : GProgressBarData)
		{
			_data = data;
			super(data);
		}

		public function set mode(value : int) : void
		{
			if (_mode == value) return;
			_mode = value;
			switch(_mode)
			{
				case GProgressBarData.POLLED:
					swap(_barSkin, _polledSkin);
					break;
				case GProgressBarData.MANUAL:
					swap(_polledSkin, _barSkin);
					break;
			}
		}

		public function set text(value : String) : void
		{
			if (value)
			{
				_label.text = value;
				_label.show();
				GLayout.layout(_label);
			}
			else
				_label.hide();
		}

		public function set value(value : int) : void
		{
			if (_value == value) return;
			_value = Math.max(0, Math.min(value, _max));
			reset();
		}

		public function get value() : int
		{
			return _value;
		}

		public function set max(value : int) : void
		{
			if (_max == value) return;
			_max = Math.max(_value, value);
			reset();
		}
	}
}
