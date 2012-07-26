package gameui.controls
{
	import gameui.core.GComponent;
	import gameui.data.GCheckBoxData;
	import gameui.data.GIconData;
	import gameui.manager.UIManager;

	import utils.BDUtil;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;



	/**
	 * Game Check Box
	 * 
	 */
	public class GCheckBox extends GComponent {

		protected var _data : GCheckBoxData;

		protected var _upSkin : Sprite;

		protected var _upIcon : BitmapData;

		protected var _selected_upIcon : BitmapData;

		protected var _icon : GIcon;

		protected var _label : GLabel;

		protected var _selected : Boolean;

		override protected function create() : void {
			_upSkin = UIManager.getUI(_data.upAsset);
			var data : GIconData = new GIconData();
			data.x = _data.padding;
			_icon = new GIcon(data);
			_upIcon = BDUtil.getBD(_data.upIcon);
			_selected_upIcon = BDUtil.getBD(_data.selectedUpIcon);
			_selected = _data.selected;
			_icon.bitmapData = (_selected ? _selected_upIcon : _upIcon);
			_label = new GLabel(_data.labelData);
			addChild(_upSkin);
			addChild(_icon);
			addChild(_label);
		}

		override protected function layout() : void {
			_label.x = _data.padding + _icon.width + _data.hGap;
			_width = _icon.width + _data.hGap + _label.width + _data.padding * 2;
			_height = Math.max(_icon.height, _label.height) + _data.padding * 2;
			_icon.y = Math.floor((_height - _icon.height) / 2);
			_label.y = Math.floor((_height - _label.height) / 2);
			_upSkin.width = _width;
			_upSkin.height = _height;
		}

		protected override function onShow() : void {
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		protected override function onHide() : void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		protected function mouseDownHandler(event : MouseEvent) : void {
			if(!_enabled)return;
			selected = !_selected;
		}

		override protected function onEnabled() : void {
			_icon.gray = !_enabled;
			_label.enabled = _enabled;
		}

		public function GCheckBox(data : GCheckBoxData) {
			_data = data;
			super(_data);
		}

		public function set selected(value : Boolean) : void {
			if(_selected == value)return;
			_selected = value;
			_icon.bitmapData = _selected ? _selected_upIcon : _upIcon;
			if(_selected)dispatchEvent(new Event(Event.SELECT));
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get selected() : Boolean {
			return _selected;
		}
		
		public function set text (value:String):void
		{
			_label.text = value;
		}
	}
}
