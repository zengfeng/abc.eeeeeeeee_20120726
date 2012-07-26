package gameui.controls
{
	import gameui.core.PhaseState;
	import gameui.core.ScaleMode;
	import gameui.data.GToggleButtonData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class GToggleButton extends GToggleBase
	{
		protected var _data : GToggleButtonData;

		protected var _upSkin : Sprite;

		protected var _overSkin : Sprite;

		protected var _downSkin : Sprite;

		protected var _disabledSkin : Sprite;

		protected var _selectedUpSkin : Sprite;

		protected var _selectedOverSkin : Sprite;

		protected var _selectedDownSkin : Sprite;

		protected var _selectedDisabledSkin : Sprite;

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
			_selectedUpSkin = UIManager.getUI(_data.selectedUpAsset);
			_selectedOverSkin = UIManager.getUI(_data.selectedOverAsset);
			_selectedDownSkin = UIManager.getUI(_data.selectedDownAsset);
			_selectedDisabledSkin = UIManager.getUI(_data.selectedDisabledAsset);
			_current = _upSkin;
			addChild(_current);
			_data.labelData.width = _data.width;
			_label = new GLabel(_data.labelData);
			addChild(_label);
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
			this.buttonMode=true;
			this.useHandCursor=true;
			this.mouseChildren=false;
			tabEnabled=false;
		}

		override protected function layout() : void
		{
			GLayout.layout(_label);
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
			if (_selectedUpSkin != null)
			{
				_selectedUpSkin.width = _width;
				_selectedUpSkin.height = _height;
			}
			if (_selectedOverSkin != null)
			{
				_selectedOverSkin.width = _width;
				_selectedOverSkin.height = _height;
			}
			if (_selectedDownSkin != null)
			{
				_selectedDownSkin.width = _width;
				_selectedDownSkin.height = _height;
			}
			if (_selectedDisabledSkin != null)
			{
				_selectedDisabledSkin.width = _width;
				_selectedDisabledSkin.height = _height;
			}
			_viewRect.x=0;
			_viewRect.y=0;
			_viewRect.width=_width;
			_viewRect.height=_height;
			this.scrollRect = _viewRect;
		}

		override protected function onEnabled() : void
		{
			_label.enabled = _enabled;
			viewSkin();
		}

		override protected  function onShow() : void
		{
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}

		override protected function onHide() : void
		{
			removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}

		override protected function onSelect() : void
		{
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
			if (_group)
			{
				if (!_selected) selected = true;
			}
			else
			{
				selected = !_selected;
			}
		}

		protected function viewSkin() : void
		{
			if (!_enabled)
			{
				_label.textColor = _data.disabledColor;
				if (selected)
				{
					if (_selectedDisabledSkin) _current = swap(_current,_selectedDisabledSkin);
				}
				else
				{
					_current = swap(_current,_disabledSkin);
				}
			}
			else if (_phase == PhaseState.UP)
			{
				_label.textColor = _data.labelData.textColor;
				if (_selected)
				{
					if (_selectedUpSkin) _current = swap(_current,_selectedUpSkin);
				}
				else
				{
					_current = swap(_current,_upSkin);
				}
			}
			else if (_phase == PhaseState.OVER)
			{
				_label.textColor = _data.textRollOverColor;
				if (_selected)
				{
					if (_selectedOverSkin) _current = swap(_current,_selectedOverSkin);
				}
				else
				{
					if (_overSkin) _current = swap(_current,_overSkin);
				}
			}
			else if (_phase == PhaseState.DOWN)
			{
				_label.textColor = _data.labelData.textColor;
				if (_selected)
				{
					if (_selectedDownSkin) _current = swap(_current,_selectedDownSkin);
				}
				else
				{
					if (_downSkin) _current = swap(_current,_downSkin);
				}
			}
		}

		public function GToggleButton(data : GToggleButtonData)
		{
			_data = data;
			super(data);
			selected = _data.selected;
		}
        
        public function get htmlText():String
        {
            return _label.htmlText;
        }
        
        public function set htmlText(str:String):void
        {
            _label.htmlText = str;
        }
	}
}
