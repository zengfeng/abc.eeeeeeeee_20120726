package gameui.controls
{
	import gameui.core.GComponent;
	import gameui.core.PhaseState;
	import gameui.core.ScaleMode;
	import gameui.data.GButtonData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * Game Button
	 * 
	 */
	public class GButton extends GComponent
	{
		protected var _data : GButtonData;
		protected var _upSkin : Sprite;
		protected var _overSkin : Sprite;
		protected var _downSkin : Sprite;
		protected var _disabledSkin : Sprite;
		protected var _label : GLabel;
		protected var _current : Sprite;
		protected var _phase : int = PhaseState.UP;
		protected var _viewRect : Rectangle = new Rectangle();

		override protected function create() : void
		{
			_upSkin = UIManager.getUI(_data.upAsset);
			_overSkin = UIManager.getUI(_data.overAsset);
			_downSkin = UIManager.getUI(_data.downAsset);
			_disabledSkin = UIManager.getUI(_data.disabledAsset);
			_current = _upSkin;
			addChild(_current);
			_data.labelData.width = _data.width;

			if (_data.labelData.text)
				addLabel();

			switch(_data.scaleMode)
			{
				case ScaleMode.SCALE_WIDTH:
					_height = _upSkin.height;
					break;
				case ScaleMode.SCALE_NONE:
					_width = _upSkin.width;
					_height = _upSkin.height;
					break;
			}
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			tabEnabled = false;
		}

		override protected function layout() : void
		{
			if (_label)
			{
				GLayout.layout(_label);
//				_label.width = _width;
			}

			_viewRect.x = 0;
			_viewRect.y = 0;

			if (_data.scaleMode != ScaleMode.SCALE_NONE)
			{
				_upSkin.width = _width;
				_upSkin.height = _height;
				if (_overSkin != null)
				{
					_overSkin.width = _width;
					_overSkin.height = _height;
				}
				if (_downSkin != null)
				{
					_downSkin.width = _width;
					_downSkin.height = _height;
				}
				if (_disabledSkin != null)
				{
					_disabledSkin.width = _width;
					_disabledSkin.height = _height;
				}

				_viewRect.width = _width;
				_viewRect.height = _height;
			}

			// this.scrollRect = _viewRect;
		}

		override protected function onEnabled() : void
		{
			if (_label)
				_label.enabled = _enabled;
			viewSkin();
		}

		override protected  function onShow() : void
		{
			super.onShow();
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			viewSkin();
		}

		override protected function onHide() : void
		{
			super.onHide();
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_phase = PhaseState.UP;
		}

		public function set phase(value : int) : void
		{
			_phase = value;
			viewSkin();
		}

		protected function rollOverHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_phase = PhaseState.OVER;
			viewSkin();
		}

		protected function rollOutHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_phase = PhaseState.UP;
			viewSkin();
		}

		protected function mouseDownHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_phase = PhaseState.DOWN;
			viewSkin();
		}

		protected function mouseUpHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_phase = ((event.currentTarget == this) ? PhaseState.OVER : PhaseState.UP);
			viewSkin();
		}

		protected function viewSkin() : void
		{
			if (!_enabled)
			{
				if (_label && !_data.isHtmlColor)
					_label.textColor = _data.disabledColor;
				_current = swap(_current, _disabledSkin);
			}
			else if (_phase == PhaseState.UP)
			{
				if (_label && !_data.isHtmlColor)
					_label.textColor = _data.labelData.textColor;
				_current = swap(_current, _upSkin);
			}
			else if (_phase == PhaseState.OVER)
			{
				if (_label && !_data.isHtmlColor)
					_label.textColor = _data.rollOverColor;
				_current = swap(_current, _overSkin);
			}
			else if (_phase == PhaseState.DOWN)
			{
				if (_label && !_data.isHtmlColor)
					_label.textColor = _data.labelData.textColor;
				_current = swap(_current, _downSkin);
			}
		}

		public function GButton(data : GButtonData)
		{
			_data = data;
			super(data);
		}

		public function resetColor(textColor : uint, rollOverColor : uint) : void
		{
			_data.labelData.textColor = textColor;
			_data.rollOverColor = rollOverColor;

			if (_label)
			{
				if (!_enabled)
				{
					_label.textColor = _data.disabledColor;
				}
				else if (_phase == PhaseState.UP)
				{
					_label.textColor = _data.labelData.textColor;
				}
				else if (_phase == PhaseState.OVER)
				{
					_label.textColor = _data.rollOverColor;
				}
				else if (_phase == PhaseState.DOWN)
				{
					_label.textColor = _data.labelData.textColor;
				}
			}
		}

		public function set text(value : String) : void
		{
			if (!_label)
				addLabel();
			_label.text = value;
			layout();
		}

		public function set htmlText(value : String) : void
		{
			if (!_label)
				addLabel();
			_label.htmlText = value;
			layout();
		}

		private function addLabel() : void
		{
			_label = new GLabel(_data.labelData);
			_label.mouseChildren=false;
			_label.mouseEnabled=false;
			addChild(label);
		}

		public function get label() : GLabel
		{
			return _label;
		}
	}
}
