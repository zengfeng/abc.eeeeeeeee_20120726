package gameui.core
{
	import gameui.manager.UIManager;

	import flash.display.DisplayObject;

	public class GAlign extends Object {

		public static const CENTER : GAlign = new GAlign(-1, -1, -1, -1, 0, 0);

		public static const HCENTER : GAlign = new GAlign(-1, -1, -1, -1, 0, -1);

		protected var _left : int = -1;

		protected var _right : int = -1;

		protected var _top : int = -1;

		protected var _bottom : int = -1;

		protected var _horizontalCenter : int = -1;

		protected var _verticalCenter : int = -1;

		public function GAlign(left : int = -1,right : int = -1,top : int = -1,bottom : int = -1,
			horizontalCenter : int = -1,verticalCenter : int = -1) {
			_left = left;
			_right = right;
			_top = top;
			_bottom = bottom;
			_horizontalCenter = horizontalCenter;
			_verticalCenter = verticalCenter;
		}

		public static function getStageCenter(target : DisplayObject,targetX : int,targetY : int) : GAlign {
			var centerX : int = UIManager.stage.stageWidth * 0.5;
			var centerY : int = UIManager.stage.stageHeight * 0.5;
			var offsetX : int = targetX - centerX + target.width * 0.5;
			var offsetY : int = targetY - centerY + target.height * 0.5;
			return new GAlign(-1, -1, -1, -1, offsetX, offsetY);
		}

		public function set left(value : int) : void {
			_left = Math.max(0, value);
			_horizontalCenter = -1;
		}

		public function get left() : int {
			return _left;
		}

		public function set right(value : int) : void {
			_right = Math.max(0, value);
			_horizontalCenter = -1;
		}

		public function get right() : int {
			return _right;
		}

		public function set top(value : int) : void {
			_top = Math.max(0, value);
			_verticalCenter = -1;
		}

		public function get top() : int {
			return _top;
		}

		public function set bottom(value : int) : void {
			_bottom = Math.max(0, value);
			_verticalCenter = -1;
		}

		public function get bottom() : int {
			return _bottom;
		}

		public function set horizontalCenter(value : int) : void {
			_horizontalCenter = value;
			_left = -1;
			_right = -1;
		}

		public function get horizontalCenter() : int {
			return _horizontalCenter;
		}

		public function set verticalCenter(value : int) : void {
			_verticalCenter = value;
			_top = -1;
			_bottom = -1;
		}

		public function get verticalCenter() : int {
			return _verticalCenter;
		}

		
		public function clone() : GAlign {
			var align : GAlign = new GAlign(_left, _right, _top, _bottom, _horizontalCenter, _verticalCenter);
			return align;
		}

		public function toString() : String {
			return _left + "," + _right + "," + _top + "," + _bottom + "," + _horizontalCenter + "," + _verticalCenter;
		}
	}
}
