package gameui.drag
{
	import gameui.manager.UIManager;

	import log4a.Logger;

	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;

	/**
	 * @author yangyiqiang
	 */
	public class DragManage
	{
		private var _dragSource : IDragSource;
		private var _dragData : DragData;
		private var _dragImage : DisplayObject;
		private var _container : Sprite;
		private static var _instance : DragManage;

		public function DragManage() : void
		{
			if (_instance)
			{
				throw Error("---DragManage--is--a--single--model---");
			}
			_instance = this;
		}

		public static function getInstance() : DragManage
		{
			if (_instance == null)
			{
				_instance = new DragManage();
			}
			return _instance;
		}

		private var _oldFilter : Array;
		private var _oldAlpha : Number;
		private var _hideMouse : Boolean;

		/*
		 * source :   被drag的对象
		 * dragData   数据
		 * container  drag 发生的容量
		 * isFilter   drage  source 是否变灰
		 * hideMouse  drage 过程中是否隐藏mouse
		 */
		public function darg(source : IDragSource, dragData : DragData, container : Sprite, isFilter : Boolean = true, hideMouse : Boolean = true, _alpha : Number = 0.4) : void
		{
			_dragSource = source;
			_dragData = dragData;
			_container = container;
			_dragImage = _dragSource.dragImage;
			if (!_dragSource) return;
			if (!_dragImage)
			{
				Logger.error("_dragImage==null error in DragManage.darg");
				return ;
			}
			_hideMouse = hideMouse;
			_oldFilter = (_dragSource as Sprite).filters;
			_oldAlpha = (_dragSource as Sprite).alpha;
			(_dragSource as Sprite).alpha = _alpha;
			var  matrix : Array = [];
			matrix = matrix.concat([0.3, 0.3, 0.3, 0, 0]);
			// red
			matrix = matrix.concat([0.3, 0.3, 0.3, 0, 0]);
			// green
			matrix = matrix.concat([0.3, 0.3, 0.3, 0, 0]);
			// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);
			// alpha
			if (isFilter)
				(_dragSource as Sprite).filters = [new ColorMatrixFilter(matrix)];
			UIManager.root.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			if (!UIManager.root.hasEventListener(MouseEvent.MOUSE_UP))
			{
				UIManager.root.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
			dragStart();
		}

		private var _hitTarget : DisplayObject;
		private var _startPoint : Point;

		protected function stage_mouseMoveHandler(event : MouseEvent) : void
		{
			if (_dragImage != null)
			{
				_dragImage.x = int(event.stageX - _dragData.stageX);
				_dragImage.y = int(event.stageY - _dragData.stageY);
			}
		}

		protected function stage_mouseUpHandler(event : MouseEvent) : void
		{
			var tempPoint : Point = _container.localToGlobal(new Point(UIManager.stage.mouseX, UIManager.stage.mouseY));
			_hitTarget = UIManager.hitTest(tempPoint.x, tempPoint.y, _container);
			_hitTarget = UIManager.findTarget(_hitTarget, IDragTarget);
			if (!_dragData.isAuto && _dragData.callBack != null)
			{
				UIManager.root.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
				if (UIManager.root.hasEventListener(MouseEvent.MOUSE_UP))
				{
					UIManager.root.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
				}
				_dragData.callBack(_hitTarget, _dragData);
				return;
			}
			if (_hitTarget && _hitTarget is IDragTarget)
			{
				if (IDragTarget(_hitTarget).dragEnter(_dragData))
				{
					dragEnd();
				}
				else
				{
					if (!_dragImage) dragEnd();
					TweenLite.to(_dragImage, 0.2, {x:_startPoint.x, y:_startPoint.y, overwrite:0, onComplete:dragEnd});
				}
			}
			else
			{
				if (!_dragImage) dragEnd();
				TweenLite.to(_dragImage, 0.2, {x:_startPoint.x, y:_startPoint.y, overwrite:0, onComplete:dragEnd});
			}
		}

		private function dragStart() : void
		{
			UIManager.dragModal = true;
			_dragImage = _dragSource.dragImage;
			_dragImage.x = int(UIManager.stage.mouseX - _dragData.stageX);
			_dragImage.y = int(UIManager.stage.mouseY - _dragData.stageY);
			_startPoint = new Point(_dragImage.x, _dragImage.y);
			UIManager.root.addChild(_dragImage);
			UIManager.root.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			if (!UIManager.root.hasEventListener(MouseEvent.MOUSE_UP))
			{
				UIManager.root.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
			if (_hideMouse)
				Mouse.hide();
		}

		private function dragEnd() : void
		{
			UIManager.dragModal = false;
			UIManager.root.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			if (UIManager.root.hasEventListener(MouseEvent.MOUSE_UP))
			{
				UIManager.root.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
			if (_dragImage)
				_dragImage.parent.removeChild(_dragImage);
			_dragImage = null;
			_dragData = null;
			(_dragSource as Sprite).filters = _oldFilter;
			(_dragSource as Sprite).alpha = _oldAlpha;
			if (_hideMouse)
				Mouse.show();
		}

		/** 
		 * 完成 drag
		 * succeed  true
		 */
		public function finishDrag(succeed : Boolean = true) : DragData
		{
			if (succeed)
			{
				dragEnd();
			}
			else
			{
				if (!_dragImage) dragEnd();
				else
					TweenLite.to(_dragImage, 0, {x:_startPoint.x, y:_startPoint.y, overwrite:0, onComplete:dragEnd});
			}
			return _dragData;
		}
	}
}
