package  gameui.skin {
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Skin
	 */
	public class Skin extends Sprite {

		protected var _width : int;

		protected var _height : int;

		protected function init() : void {
			create();
			layout();
		}

		protected function create() : void {
		}

		protected function layout() : void {
		}

		protected function onShow() : void {
		}

		protected function onHide() : void {
		}

		protected function addToStageHandler(event : Event) : void {
			onShow();
		}

		protected function removeFromStageHandler(event : Event) : void {
			onHide();
		}

		public function Skin() {
			init();
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}

		override public function set width(value : Number) : void {
			if(_width == value)return;
			_width = value;
			layout();
		}

		override public function get width() : Number {
			return _width;
		}

		override public function set height(value : Number) : void {
			if(_height == value)return;
			_height = value;
			layout();
		}

		override public function get height() : Number {
			return _height;
		}

		public function moveTo(newX : int,newY : int) : void {
			x = newX;
			y = newY;
		}

		public function setSize(w : int,h : int) : void {
			_width = w;
			_height = h;
			layout();
			dispatchEvent(new Event(Event.RESIZE));
		}

		public function clone() : Skin {
			return new Skin();
		}
	}
}