package gameui.containers
{
	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;
	import utils.MathUtil;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GTitleWindow extends GComponent
	{
		protected var _data : GTitleWindowData;

		protected var _titleBar : GTitleBar;

		protected var _contentPanel : GPanel;

		protected var _modalSkin : Sprite;

		protected var _regX : int;

		protected var _regY : int;

		protected var _closeButton : GButton;

		override protected function create() : void
		{
			_data.titleBarData.width=_width;
			_titleBar = new GTitleBar(_data.titleBarData);
			_contentPanel = new GPanel(_data.panelData);
			_closeButton = new GButton(_data.closeButtonData);
			_contentPanel.y = _titleBar.height;
			addChild(_contentPanel);
			addChild(_titleBar);
			addChild(_closeButton);
			if (_data.modal)
			{
				_modalSkin = ASSkin.modalSkin;
			}
		}

		override protected function layout() : void
		{
			_contentPanel.setSize(_width,_height - _titleBar.height - 1);
			_closeButton.x = _width - 25;
			_closeButton.y = 5;
		}

		override protected function onShow() : void
		{
			if (_data.modal)
			{
				var topLeft : Point = parent.localToGlobal(MathUtil.ORIGIN);
				_modalSkin.x = -topLeft.x;
				_modalSkin.y = -topLeft.y;
				_modalSkin.width = UIManager.stage.stageWidth;
				_modalSkin.height = UIManager.stage.stageHeight;
				var index : int = parent.getChildIndex(this);
				parent.addChildAt(_modalSkin,index - 1);
//				parent.swapChildrenAt(parent.getChildIndex(this),parent.numChildren - 1);
			}
			if (_data.allowDrag)
			{
				_titleBar.addEventListener(MouseEvent.MOUSE_DOWN,titleBar_mouseDownHandler);
			}
			_closeButton.addEventListener(MouseEvent.CLICK,clickClose);
			_closeButton.enabled=true;
		}

		override protected function onHide() : void
		{
			if (_data.modal)
			{
				_modalSkin.parent.removeChild(_modalSkin);
			}
			if (_data.allowDrag)
			{
				_titleBar.removeEventListener(MouseEvent.MOUSE_DOWN,titleBar_mouseDownHandler);
				if (stage.hasEventListener(MouseEvent.MOUSE_MOVE))
				{
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,stage_mouseMoveHandler);
				}
				if (stage.hasEventListener(MouseEvent.MOUSE_UP))
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler);
				}
			}
			_closeButton.removeEventListener(MouseEvent.CLICK,clickClose);
		}
		
		private function clickClose(event:MouseEvent):void
		{
			_closeButton.enabled=false;
			onClickClose(event);
		}

		protected function onClickClose(event : MouseEvent) : void
		{
			hide();
			_closeButton.enabled=false;
		}

		private function titleBar_mouseDownHandler(event : MouseEvent) : void
		{
			startDragging(event);
		}

		private function startDragging(event : MouseEvent) : void
		{
			_regX = event.stageX - x;
			_regY = event.stageY - y;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,stage_mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler);
		}

		private function stage_mouseMoveHandler(event : MouseEvent) : void
		{
			if (isNaN(_regX) || isNaN(_regY)) return;
			var newX : int = Math.min(stage.stageWidth - _width,event.stageX - _regX);
			var newY : int = Math.min(stage.stageHeight - _height,event.stageY - _regY);
			newX = newX < 0 ? 0 : newX;
			newY = newY < 0 ? 0 : newY;
			moveTo(newX,newY);
		}

		private function stage_mouseUpHandler(event : MouseEvent) : void
		{
			if (!isNaN(_regX)) stopDragging();
		}

		private function stopDragging() : void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,stage_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler);
			_regX = NaN;
			_regY = NaN;
		}

		public function GTitleWindow(data : GTitleWindowData)
		{
			_data = data;
			super(data);
		}

		public function get contentPanel() : GPanel
		{
			return _contentPanel;
		}

		public function get modal() : Boolean
		{
			return _data.modal;
		}

		public function resizeModal() : void
		{
			if (_modalSkin == null) return;
			_modalSkin.width = UIManager.stage.stageWidth;
			_modalSkin.height = UIManager.stage.stageHeight;
		}

		public function set title(value : String) : void
		{
			if (_titleBar)
				_titleBar.htmlText = value;
		}
	}
}