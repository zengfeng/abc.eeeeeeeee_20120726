package gameui.cell
{
	import gameui.controls.GIcon;
	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.PhaseState;
	import gameui.core.ScaleMode;
	import gameui.data.GLabelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;


	/**
	 * Game Cell
	 */
	public class GCell extends GComponent {

		public static const SELECT : String = "select";

		public static const SINGLE_CLICK : String = "singleClick";

		public static const DOUBLE_CLICK : String = "doubleClick";

		protected var _data : GCellData;

		protected var _upSkin : Sprite;

		protected var _overSkin : Sprite;

		protected var _selected_upSkin : Sprite;

		protected var _selected_overSkin : Sprite;

		protected var _disabledSkin : Sprite;

		protected var _lockIcon : GIcon;

		protected var _key_lb : GLabel;

		protected var _selected : Boolean = false;

		protected var _current : Sprite;

		protected var _timer : Timer;

		protected var _count : int;

		protected var _ctrlKey : Boolean = false;

		protected var _shiftKey : Boolean = false;

		protected var _phase : int = PhaseState.UP;

		protected var _rollOver : Boolean = false;
		
		protected var _viewRect : Rectangle = new Rectangle();

		override protected function create() : void {
			_upSkin = UIManager.getUI(_data.upAsset);
			_overSkin = UIManager.getUI(_data.overAsset);
			_selected_upSkin = UIManager.getUI(_data.selected_upAsset);
			_selected_overSkin = UIManager.getUI(_data.selected_overAsset);
			_disabledSkin = UIManager.getUI(_data.disabledAsset);
			_current = _upSkin;
			addChild(_current);
			_data.lockIconData.parent = this;
			_lockIcon = new GIcon(_data.lockIconData);
			addKeyLabel();
			switch(_data.scaleMode) {
				case ScaleMode.SCALE_WIDTH:
					_height = _upSkin.height;
					break;
				case ScaleMode.SCALE_NONE:
					_width = _upSkin.width;
					_height = _upSkin.height;
					break;
			}
		}

		protected function addKeyLabel() : void {
			if(_data.hotKey == null)return;
			var data : GLabelData = new GLabelData();
			data.text = _data.hotKey;
			data.textColor = 0xFFFFFF;
			data.textFieldFilters = UIManager.getEdgeFilters(0x000000, 0.9);
			data.align = new GAlign(-1, 3, 2, -1, -1, -1);
			_key_lb = new GLabel(data);
			addChild(_key_lb);
		}

		override protected function layout() : void {
			_upSkin.width = _width;
			_upSkin.height = _height;
			if(_overSkin != null) {
				_overSkin.width = _width;
				_overSkin.height = _height;
			}
			if(_selected_upSkin != null) {
				_selected_upSkin.width = _width;
				_selected_upSkin.height = _height;
			}
			if(_selected_overSkin != null) {
				_selected_overSkin.width = _width;
				_selected_overSkin.height = _height;
			}
			if(_disabledSkin != null) {
				_disabledSkin.width = _width;
				_disabledSkin.height = _height;
			}
			GLayout.layout(_key_lb);
			_viewRect.x = 0;
			_viewRect.y = 0;
			_viewRect.width = _width;
			_viewRect.height = _height;
			this.scrollRect = _viewRect;
		}

		override protected function onEnabled() : void {
			if(!_enabled && _timer.running)_timer.stop();
			viewSkin();
		}

		override protected function onShow() : void {
			if(_data.allowDoubleClick) {
				_count = 0;
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				addEventListener(MouseEvent.CLICK, clickHandler);
			} else {
				addEventListener(MouseEvent.CLICK, singleClickHandler);
			}
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		override protected function onHide() : void {
			if(_data.allowDoubleClick) {
				if(_timer.running)_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				removeEventListener(MouseEvent.CLICK, clickHandler);
			} else {
				removeEventListener(MouseEvent.CLICK, singleClickHandler);
			}
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_phase = PhaseState.UP;
			viewSkin();
		}

		protected function viewSkin() : void {
			if (!_enabled) {
				if(selected) {
				} else {
					_current = swap(_current, _disabledSkin);
				}
			}else if(_phase == PhaseState.UP) {
				if(_selected) {
					_current = swap(_current, _selected_upSkin);
				} else {
					_current = swap(_current, _upSkin);
				}
			}else if (_phase == PhaseState.OVER) {
				if(_selected) {
					_current = swap(_current, _selected_overSkin);
				} else {
					_current = swap(_current, _overSkin);
				}
			}else if(_phase == PhaseState.DOWN) {
				if(_selected) {
				} else {
				}
			}
		}

		protected function rollOverHandler(event : MouseEvent) : void {
			if(!_enabled)return;
			_rollOver = true;
			_phase = PhaseState.OVER;
			viewSkin();
		}

		protected function rollOutHandler(event : MouseEvent) : void {
			if(!_enabled)return;
			_rollOver = false;
			_phase = PhaseState.UP;
			viewSkin();
		}

		protected function mouseUpHandler(event : MouseEvent) : void {
			if(!_enabled)return;
			_phase = (_rollOver ? PhaseState.OVER : PhaseState.UP);
			viewSkin();
		}

		protected function timerHandler(event : TimerEvent) : void {
			_count = 0;
			onSingleClick();
		}

		protected function mouseDownHandler(event : MouseEvent) : void {
			if(!_enabled)return;
			if(_timer.running)_timer.stop();
		}

		protected function clickHandler(event : MouseEvent) : void {
			_ctrlKey = event.ctrlKey;
			_shiftKey = event.shiftKey;
			if (_count == 1) {
				if(_timer.running) {
					_timer.stop();
				}
				_count = 0;
				onDoubleClick();
			} else {
				_count++;
				_timer.reset();
				_timer.start();
			}
		}

		protected function singleClickHandler(event : MouseEvent) : void {
			_ctrlKey = event.ctrlKey;
			_shiftKey = event.shiftKey;
			onSingleClick();
		}

		protected function onSingleClick() : void {
			if(_data.allowSelect && _data.clickSelect) {
				if(!_selected) {
					selected = true;
				}
			}
			dispatchEvent(new Event(GCell.SINGLE_CLICK,true));
		}

		protected function onDoubleClick() : void {
			if(_data.allowSelect && _data.clickSelect) {
				if(!_selected) {
					selected = true;
				}
			}
			dispatchEvent(new Event(GCell.DOUBLE_CLICK));
		}

		protected function onSelected() : void {
			// this is abstract function
		}

		public function GCell(data : GCellData) {
			_timer = new Timer(150, 1);
			_data = data;
			super(data);
			lock = _data.lock;
		}

		public function set selected(value : Boolean) : void {
			if(_selected == value)return;
			_selected = value;
			viewSkin();
			onSelected();
			if(_selected)dispatchEvent(new Event(GCell.SELECT));
		}

		public function get selected() : Boolean {
			return _selected;
		}

		public function set lock(value : Boolean) : void {
			if(value) {
				_lockIcon.show();
				GLayout.layout(_lockIcon);
			} else {
				_lockIcon.hide();
			}
		}

		public function get ctrlKey() : Boolean {
			return _ctrlKey;
		}

		public function get shiftKey() : Boolean {
			return _shiftKey;
		}

		public function get data() : GCellData {
			return _data;
		}

		public function clone() : GCell {
			var cell : GCell = new GCell(_data.clone());
			cell.source = _source;
			return cell;
		}
	}
}
