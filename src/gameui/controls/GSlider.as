package gameui.controls
{
	import gameui.core.GComponent;
	import gameui.data.GSliderData;
	import gameui.manager.UIManager;

	import model.RangeModel;

	import utils.ColorMatrixUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;




	/**
	 * Game Slider
	 * 
	 */
	public class GSlider extends GComponent {

		public static const VERTICAL : String = "vertical";

		public static const HORIZONTAL : String = "horizontal";

		private var _data : GSliderData;

		private var _direction : String = GSlider.HORIZONTAL;

		private var _trackSkin : Sprite;

		private var _thumbSkin : Sprite;

		private var _barSkin : Sprite;

		private var _model : RangeModel;

		private var _zero : int = 0;

		private var _cmf : ColorMatrixFilter;

		override protected function create() : void {
			_trackSkin = UIManager.getUI(_data.trackAsset);
			_trackSkin.mouseEnabled = true;
			_thumbSkin = UIManager.getUI(_data.thumbAsset);
			_thumbSkin.mouseEnabled = true;
			_barSkin = UIManager.getUI(_data.barAsset);
			_trackSkin.height = _data.height;
			_barSkin.width = 0;
			_barSkin.height = _data.height;
			addChild(_trackSkin);
			addChild(_barSkin);
			addChild(_thumbSkin);
			_cmf = new ColorMatrixFilter(ColorMatrixUtil.adjustHue(60));
		}

		override protected function layout() : void {
			_trackSkin.width = _width;
		}

		private function reset() : void {
			var w : int = _trackSkin.width - 1;
			_thumbSkin.x = Math.round(_model.percent * w);
			_zero = _model.zeroPercenr * w;
			var position : int = Math.round(_model.percent * w);
			if(_model.value < 0) {
				_barSkin.filters = [_cmf];
				_barSkin.x = position;
				_barSkin.width = _zero - position;
			} else {
				_barSkin.filters = null;
				_barSkin.x = _zero;
				_barSkin.width = position - _zero;
			}
		}

		override protected function onShow() : void {
			_thumbSkin.addEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		}

		override protected function onHide() : void {
			_thumbSkin.removeEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler);
			removeEventListener(MouseEvent.CLICK, clickHandler);
			removeEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		}

		private function thumb_mouseDownHandler(event : MouseEvent) : void {
			if(!_enabled)return;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
		}

		private function stage_mouseMoveHandler(event : MouseEvent) : void {
			var w : int = _trackSkin.width - 1;
			var position : int = Math.max(0, Math.min(w, mouseX));
			var newValue : int = Math.round(position / w * (_model.max - _model.min) + _model.min);
			_model.value = newValue;
		}

		private function stage_mouseUpHandler(event : MouseEvent) : void {
			stopDragging();
		}

		private function stopDragging() : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false);
		}

		private function clickHandler(event : MouseEvent) : void {
			var w : int = _trackSkin.width - 1;
			var position : int = Math.max(0, Math.min(w, mouseX));
			var newValue : int = Math.round(position / w * (_model.max - _model.min) + _model.min);
			_model.value = newValue;
		}

		private function wheelHandler(event : MouseEvent) : void {
			_model.value -= event.delta;
		}

		private function model_changeHandler(event : Event) : void {
			reset();
		}

		public function GSlider(data : GSliderData) {
			_data = data;
			super(data);
			_model = new RangeModel();
			_model.addEventListener(Event.CHANGE, model_changeHandler);
		}

		public function set model(value : RangeModel) : void {
			if(_model != null) {
				_model.removeEventListener(Event.CHANGE, model_changeHandler);
			}
			_model = value;
			if(_model != null) {
				_model.addEventListener(Event.CHANGE, model_changeHandler);
				reset();
			}
		}

		public function get model() : RangeModel {
			return _model;
		}

		public function set direction(value : String) : void {
			if(_direction == value)return;
			_direction = value;
			if(_direction == HORIZONTAL) {
				rotation = 0;
				scaleX = 1;
			} else {
				rotation = -90;
				scaleX = -1;
			}
		}

		override public function setSize(width : int,height : int) : void {
			if(_direction == HORIZONTAL) {
				super.setSize(height, width);
			} else {
				super.setSize(width, height);
			}
		}

		override public function set width(value : Number) : void {
			if(_direction == HORIZONTAL) {
				super.width = value;
			} else {
				super.height = value;
			}
		}

		override public function get width() : Number {
			return (_direction == HORIZONTAL) ? _width : _height;
		}

		override public function set height(value : Number) : void {
			if(_direction == HORIZONTAL) {
				super.height = value;
			} else {
				super.width = value;
			}
		}

		override public function get height() : Number {
			return (_direction == HORIZONTAL) ? _height : _width;
		}

		override public function set enabled(b : Boolean) : void {
			if(_enabled == b)return;
			_enabled = b;
			if(_enabled) {
				_thumbSkin.filters = [];
			} else {
				_thumbSkin.filters = [new ColorMatrixFilter(ColorMatrixUtil.GRAY)];
			}
		}
	}
}
