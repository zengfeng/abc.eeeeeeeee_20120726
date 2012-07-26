package gameui.controls {
	import gameui.data.GIconData;
	import gameui.data.GRadioButtonData;
	import gameui.manager.UIManager;

	import utils.BDUtil;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class GRadioButton extends GToggleBase {
		protected var _data : GRadioButtonData;
		protected var _upSkin : DisplayObject;
		protected var _upIcon : BitmapData;
		protected var _selected_upIcon : BitmapData;
		protected var _overIcon : BitmapData;
		protected var _icon : GIcon;
		protected var _label : GLabel;
		protected var _viewRect : Rectangle = new Rectangle();
		
		override protected function create() : void {
			_upSkin = UIManager.getUI(_data.upAsset);
			_upIcon = BDUtil.getBD(_data.upIcon);
			_selected_upIcon = BDUtil.getBD(_data.selectedUpIcon);
			var data : GIconData =_data.iconData;
			data.x = _data.padding;
			_icon = new GIcon(data);
			_selected = _data.selected;
			_icon.bitmapData = (_data.selected ? _selected_upIcon : _upIcon);
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
			_viewRect.x = 0;
			_viewRect.y = 0;
			_viewRect.width = _width;
			_viewRect.height = _height;
			this.scrollRect = _viewRect;
		}

		protected function mouseDownHandler(event : MouseEvent) : void {
			if (!_enabled) return;
			if (_group) {
				if (!_selected) selected = true;
			} else {
				selected = !_selected;
			}
		}

		override protected function onSelect() : void {
			_icon.bitmapData = (_selected ? _selected_upIcon : _upIcon);
		}

		override protected function onEnabled() : void {
			_icon.gray = !_enabled;
			_label.enabled = _enabled;
			_label.textColor = _enabled?0x2F1F000:0x999999;
		}

		protected override function onShow() : void {
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			if (_data.overIcon) {
				addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			}
		}

		protected function mouseOverHandler(event : MouseEvent) : void {
			if (!_selected)
				_icon.bitmapData = _overIcon;
		}

		protected function mouseOutHandler(event : MouseEvent) : void {
			_icon.bitmapData = (_selected ? _selected_upIcon : _upIcon);
		}

		protected override function onHide() : void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			if (_data.overIcon) {
				removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			}
		}

		public function GRadioButton(data : GRadioButtonData) {
			_data = data;
			super(data);
		}
	}
}
