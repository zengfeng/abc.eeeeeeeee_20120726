package gameui.cell
{
	import gameui.core.GComponent;
	import gameui.core.PhaseState;
	import gameui.core.ScaleMode;
	import gameui.manager.UIManager;

	import model.TreeNode;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author yangyiqiang
	 */
	public class TreeCell extends GComponent
	{
		public static const OPEN_CLICK : String = "openClick";

		public static const CLOSE_CLICK : String = "closeClick";

		protected var _data : GTreeCellData;

		protected var _upSkin : Sprite;

		protected var _overSkin : Sprite;

		protected var _selected_upSkin : Sprite;

		protected var _selected_overSkin : Sprite;

		protected var _disabledSkin : Sprite;

		protected var _selected : Boolean = false;

		protected var _current : Sprite;

		protected var _phase : int = PhaseState.UP;

		protected var _rollOver : Boolean = false;
		
		protected var _viewRect : Rectangle = new Rectangle();

		override protected function create() : void
		{
			_upSkin = UIManager.getUI(_data.upAsset);
			_overSkin = UIManager.getUI(_data.overAsset);
			_selected_upSkin = UIManager.getUI(_data.selected_upAsset);
			_selected_overSkin = UIManager.getUI(_data.selected_overAsset);
			_disabledSkin = UIManager.getUI(_data.disabledAsset);
			_current = _upSkin;
			addChild(_current);
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
			_upSkin.width = _width;
			_upSkin.height = _height;
			if (_overSkin != null)
			{
				_overSkin.width = _width;
				_overSkin.height = _height;
			}
			if (_selected_upSkin != null)
			{
				_selected_upSkin.width = _width;
				_selected_upSkin.height = _height;
			}
			if (_selected_overSkin != null)
			{
				_selected_overSkin.width = _width;
				_selected_overSkin.height = _height;
			}
			if (_disabledSkin != null)
			{
				_disabledSkin.width = _width;
				_disabledSkin.height = _height;
			}
			_viewRect.x = 0;
			_viewRect.y = 0;
			_viewRect.width = _width;
			_viewRect.height = _height;
			this.scrollRect = _viewRect;
		}

		override protected function onShow() : void
		{
			addEventListener(MouseEvent.CLICK,singleClickHandler);
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}

		override protected function onHide() : void
		{
			removeEventListener(MouseEvent.CLICK,singleClickHandler);
			removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			_phase = PhaseState.UP;
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

		protected function mouseUpHandler(event : MouseEvent) : void
		{
			if (!_enabled) return;
			_phase = (_rollOver ? PhaseState.OVER : PhaseState.UP);
			viewSkin();
		}

		protected function singleClickHandler(event : MouseEvent) : void
		{
			onSingleClick();
		}

		protected function onSingleClick() : void
		{
			if (_data.allowSelect && _data.clickSelect)
			{
				if (!_selected)
				{
					selected = true;
					TreeNode(_source).setOpen(true);
				}
				else
				{
					selected = false;
					TreeNode(_source).setOpen(false);
				}
			}
			dispatchEvent(new Event(GCell.SINGLE_CLICK,true));
		}

		protected function viewSkin() : void
		{
			if (!_enabled)
			{
				if (selected)
				{
				}
				else
				{
					_current = swap(_current,_disabledSkin);
				}
			}
			else if (_phase == PhaseState.UP)
			{
				if (_selected)
				{
					_current = swap(_current,_selected_upSkin);
				}
				else
				{
					_current = swap(_current,_upSkin);
				}
			}
			else if (_phase == PhaseState.OVER)
			{
				if (_selected)
				{
					_current = swap(_current,_selected_overSkin);
				}
				else
				{
					_current = swap(_current,_overSkin);
				}
			}
			else if (_phase == PhaseState.DOWN)
			{
				if (_selected)
				{
				}
				else
				{
				}
			}
		}

		public function set selected(value : Boolean) : void
		{
			if (_selected == value) return;
			_selected = value;
			viewSkin();
			onSelected();
			if (_selected) dispatchEvent(new Event(GCell.SELECT));
		}

		public function get selected() : Boolean
		{
			return _selected;
		}

		protected function onSelected() : void
		{
			// this is abstract function
		}

		override public function set source(value : *) : void
		{
			_source = value;
		}

		public function TreeCell(data : GTreeCellData)
		{
			super(data);
		}

		public function close() : void
		{
		}

		public function open() : void
		{
		}
	}
}
