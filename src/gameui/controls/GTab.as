package gameui.controls
{
	import gameui.core.PhaseState;
	import gameui.core.ScaleMode;
	import gameui.data.GTabData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GTab extends GToggleBase
	{
		protected var _data : GTabData;
		protected var _upSkin : Sprite;
		protected var _overSkin : Sprite;
		protected var _disabledSkin : Sprite;
		protected var _selectedUpSkin : Sprite;
		protected var _selectedDisabledSkin : Sprite;
		protected var _label : GLabel;
		protected var _current : Sprite;
		protected var _phase : int = PhaseState.UP;
		protected var _rollOver : Boolean = false;

		override protected function create() : void
		{
			_upSkin = UIManager.getUI(_data.upAsset);
			_overSkin = UIManager.getUI(_data.overAsset);
			_disabledSkin = UIManager.getUI(_data.disabledAsset);
			_selectedUpSkin = UIManager.getUI(_data.selectedUpAsset);
			_selectedDisabledSkin = UIManager.getUI(_data.selectedDisabledAsset);
			_current = _upSkin;
			addChild(_upSkin);

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
		}

		override protected function layout() : void
		{
			GLayout.layout(_label);
			_upSkin.width = _width;
			_upSkin.height = _height;
			if (_overSkin)
			{
				_overSkin.width = _width;
				_overSkin.height = _height;
			}
			if (_disabledSkin)
			{
				_disabledSkin.width = _width;
				_disabledSkin.height = _height;
			}
			if (_selectedUpSkin)
			{
				_selectedUpSkin.width = _width;
				_selectedUpSkin.height = _height;
			}
			if (_selectedDisabledSkin)
			{
				_selectedDisabledSkin.width = _width;
				_selectedDisabledSkin.height = _height;
			}
		}

		override protected  function onShow() : void
		{
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		override protected function onHide() : void
		{
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		override protected function onSelect() : void
		{
			viewSkin();
		}

		protected function rollOverHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_rollOver = true;
			_phase = PhaseState.OVER;
			viewSkin();
		}

		protected function rollOutHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_rollOver = false;
			_phase = PhaseState.UP;
			viewSkin();
		}

		protected function mouseDownHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_phase = PhaseState.DOWN;
			if (_group)
			{
				if (!_selected) selected = true;
			}
			else
			{
				selected = !_selected;
			}
			viewSkin();
		}

		protected function mouseUpHandler(event : MouseEvent) : void
		{
			if (_phase != PhaseState.DOWN) return;
			if (!_enabled) return;
			_phase = PhaseState.UP;
			viewSkin();
		}

		protected function viewSkin() : void
		{
			if (!_enabled)
			{
				if (selected)
				{
					if (_selectedDisabledSkin) _current = swap(_current, _selectedDisabledSkin);
				}
				else
				{
					_current = swap(_current, _disabledSkin);
				}
			}
			else if (_phase == PhaseState.UP)
			{
				if (_selected)
				{
					if (_selectedUpSkin) _current = swap(_current, _selectedUpSkin);
					if (_label)
						_label.textColor = _data.textSelectedColor;
				}
				else
				{
					_current = swap(_current, _upSkin);
					if (_label)
						_label.textColor = _data.labelData.textColor;
				}
			}
			else if (_phase == PhaseState.OVER)
			{
				if (_selected)
				{
				}
				else
				{
					if (_overSkin) _current = swap(_current, _overSkin);
				}
				if (_label)
					_label.textColor = _data.textRollOverColor;
			}
			else if (_phase == PhaseState.DOWN)
			{
			}
		}

		public function GTab(data : GTabData)
		{
			_data = data;
			super(_data);
			selected = _data.selected;
		}

		public function set text(value : String) : void
		{
			_label.text = value;
			if (value && !_label)
				addLabel();

			if (_data.scaleMode == ScaleMode.AUTO_WIDTH)
			{
				_width = _label.width + _data.padding * 2;
				layout();
			}
			else
			{
				GLayout.layout(_label);
			}
		}

		private function addLabel() : void
		{
			_label = new  GLabel(_data.labelData);
			addChild(_label);
		}
	}
}
