package  gameui.drag {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class DragObject {

		private var _target : DisplayObject;

		//private var _callback : Callback;

		private var _regX : int;

		private var _regY : int;

		private function mouseDownHandler(event : MouseEvent) : void {
			_regX = event.stageX - _target.x;
			_regY = event.stageY - _target.y;
			_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function mouseMoveHandler(event : MouseEvent) : void {
			var newX : int = event.stageX - _regX;
			var newY : int = event.stageY - _regY;
			newX = Math.max(0, Math.min(_target.parent.width - _target.width, newX));
			newY = Math.max(0, Math.min(_target.parent.height - _target.height, newY));
			//_callback.execute(newX, newY);
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_target.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		//public function DragObject(target : DisplayObject,callback : Callback) {
		//	_target = target;
		//	_callback = callback;
		//}

		public function start() : void {
			_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		public function end() : void {
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
	}
}
