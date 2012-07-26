package gameui.containers
{
	import gameui.controls.GScrollBar;
	import gameui.core.GComponent;
	import gameui.core.ScaleMode;
	import gameui.data.GPanelData;
	import gameui.data.GScrollBarData;
	import gameui.events.GScrollBarEvent;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;

	import utils.MathUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Game Panel
	 */
	public class GPanel extends GComponent
	{
		protected var _data : GPanelData;

		protected var _bgSkin : Sprite;

		protected var _content : Sprite;

		protected var _modalSkin : Sprite;

		protected var _viewW : int;

		protected var _viewH : int;

		protected var _viewRect : Rectangle = new Rectangle();

		protected var _bounds : Rectangle = new Rectangle();

		protected var _v_sb : GScrollBar;

		protected var _h_sb : GScrollBar;

		protected var _menuTrigger : DisplayObject;

		override protected function create() : void
		{
			_bgSkin = UIManager.getUI(_data.bgAsset);
			_content = new Sprite();
			_content.name = "content";
			_content.x = this._content.y = _data.padding;
			addChild(_bgSkin);
			addChild(_content);
			if (_data.modal) _modalSkin = ASSkin.modalSkin;
			switch(_data.scaleMode)
			{
				case ScaleMode.SCALE_WIDTH:
					_height = _bgSkin.height;
					break;
				case ScaleMode.SCALE_NONE:
					var offset : Point = UIManager.getOffset(_bgSkin);
					_width = _bgSkin.width + offset.x;
					_height = _bgSkin.height + offset.y;
					break;
			}
			if (_data.verticalScrollPolicy == GPanelData.ON)
				createScroll(GScrollBarData.VERTICAL);
			if (_data.horizontalScrollPolicy == GPanelData.ON)
				createScroll(GScrollBarData.HORIZONTAL);
		}

		override protected function layout() : void
		{
			_bgSkin.width = _width;
			_bgSkin.height = _height;
			_viewW = Math.max(_base.minWidth, _width - _data.padding * 2);
			_viewH = Math.max(_base.minHeight, _height - _data.padding * 2);
			_viewRect.width = _viewW;
			_viewRect.height = _viewH;
			_content.scrollRect = _viewRect;
			layoutScroll();
			reset();
		}

		private  function layoutScroll() : void
		{
			if (_v_sb)
			{
				_v_sb.x = _width - _data.padding - _v_sb.width;
				_v_sb.y = _data.padding;
			}
			if (_h_sb)
			{
				_h_sb.x = _data.padding;
				_h_sb.y = _height - _data.padding - _h_sb.height;
			}
		}

		private function createScroll(direction : int) : void
		{
			if (direction == GScrollBarData.HORIZONTAL)
			{
				if (_h_sb) return ;
				var hdata : GScrollBarData = _data.scrollBarData.clone();
				hdata.direction = direction;
				_h_sb = new GScrollBar(hdata);
				addChild(_h_sb);
			}
			else if (direction == GScrollBarData.VERTICAL)
			{
				if (_v_sb) return ;
				var vdata : GScrollBarData = _data.scrollBarData.clone();
				vdata.direction = direction;
				_v_sb = new GScrollBar(vdata);
				addChild(_v_sb);
			}
		}

		public function reset() : void
		{
			resetBounds();
			var needV : Boolean = _bounds.height > _viewH;
			var needH : Boolean = _bounds.width > _viewW;
			if (_data.horizontalScrollPolicy == GPanelData.AUTO && needH)
				createScroll(GScrollBarData.HORIZONTAL);
			if (_data.verticalScrollPolicy == GPanelData.AUTO && needV)
				createScroll(GScrollBarData.VERTICAL);
			var newW : Number = _viewW - ((needV && _v_sb) ? _v_sb.width : 0);
			var newH : Number = _viewH - ((needH && _h_sb) ? _h_sb.height : 0);
			if (_viewRect.width != newW || _viewRect.height != newH)
			{
				_viewRect.width = newW;
				_viewRect.height = newH;
				resizeContent();
				reset();
				return;
			}
			resetVScroll(needV, newH);
			resetHScroll(needH, newW);
			layoutScroll();
			_content.scrollRect = _viewRect;
		}

		private function resetVScroll(needV : Boolean, newH : Number) : void
		{
			if (_data.verticalScrollPolicy == GPanelData.OFF) return;
			if (_v_sb && _v_sb.parent && !_v_sb.hasEventListener(GScrollBarEvent.SCROLL))
				_v_sb.addEventListener(GScrollBarEvent.SCROLL, scrollHandler);
			if (_data.verticalScrollPolicy == GPanelData.ON)
			{
				_v_sb.height = newH;
				_v_sb.resetValue(newH, 0, _bounds.height - newH, (_content.scrollRect ? _content.scrollRect.y : 0));
				return;
			}
			if (needV)
			{
				_v_sb.height = newH;
				_v_sb.resetValue(newH, 0, _bounds.height - newH, (_content.scrollRect ? _content.scrollRect.y : 0));
				addChild(_v_sb);
			}
			else if (_v_sb && _v_sb.visible)
			{
				_v_sb.removeEventListener(GScrollBarEvent.SCROLL, scrollHandler);
				_viewRect.y = 0;
				if (_v_sb.parent) _v_sb.parent.removeChild(_v_sb);
			}
		}

		private function resetHScroll(needH : Boolean, newW : Number) : void
		{
			if (_data.horizontalScrollPolicy == GPanelData.OFF) return;
			if (_h_sb && _h_sb.parent && !_h_sb.hasEventListener(GScrollBarEvent.SCROLL))
				_h_sb.addEventListener(GScrollBarEvent.SCROLL, scrollHandler);
			if (_data.horizontalScrollPolicy == GPanelData.ON)
			{
				_h_sb.width = newW;
				_h_sb.resetValue(newW, 0, _bounds.width - newW, (_content.scrollRect ? +_content.scrollRect.x : 0));
				return;
			}
			if (needH)
			{
				_h_sb.width = newW;
				_h_sb.resetValue(newW, 0, _bounds.width - newW, (_content.scrollRect ? +_content.scrollRect.x : 0));
				addChild(_h_sb);
			}
			else if (_h_sb && _h_sb.visible)
			{
				_viewRect.x = 0;
				_h_sb.removeEventListener(GScrollBarEvent.SCROLL, scrollHandler);
				if (_h_sb.parent) _h_sb.parent.removeChild(_h_sb);
			}
		}

		protected function resizeContent() : void
		{
		}

		protected function resetBounds() : void
		{
			var total : int = _content.numChildren;
			var x : Number = 0;
			var y : Number = 0;
			var w : Number = _base.minWidth;
			var h : Number = _base.minHeight;
			for (var i : int = 0;i < total;i++)
			{
				var child : DisplayObject = _content.getChildAt(i);
				x = Math.min(x, child.x);
				y = Math.min(y, child.y);
				w = Math.max(w, child.x + child.width);
				h = Math.max(h, child.y + child.height);
			}
			_bounds = new Rectangle(x, y, w, h);
		}

		protected function scrollHandler(event : GScrollBarEvent) : void
		{
			if (event.direction == GScrollBarData.VERTICAL)
			{
				_viewRect.y = event.position;
			}
			else
			{
				_viewRect.x = event.position;
			}
			_content.scrollRect = _viewRect;
		}

		override protected function onShow() : void
		{
			if (_data.modal)
			{
				UIManager.stage.focus = null;
				var topLeft : Point = parent.localToGlobal(MathUtil.ORIGIN);
				_modalSkin.x = -topLeft.x;
				_modalSkin.y = -topLeft.y;
				_modalSkin.width = UIManager.stage.stageWidth;
				_modalSkin.height = UIManager.stage.stageHeight;
				parent.addChildAt(_modalSkin, parent.numChildren - 1);
				parent.swapChildrenAt(parent.getChildIndex(this), parent.numChildren - 1);
			}
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			if (_menuTrigger != null)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
		}

		override protected function onHide() : void
		{
			if (_data.modal)
			{
				_modalSkin.parent.removeChild(_modalSkin);
			}
			removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			if (_menuTrigger != null)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
		}

		protected function mouseWheelHandler(event : MouseEvent) : void
		{
			if (_v_sb && _v_sb.visible)
			{
				event.stopPropagation();
				_v_sb.scroll(event.delta);
			}
		}

		protected function stage_mouseUpHandler(event : MouseEvent) : void
		{
			var hitTarget : DisplayObject = UIManager.hitTest(stage.mouseX, stage.mouseY);
			if (!UIManager.atParent(hitTarget, this))
			{
				var outside : Boolean = true;
				if (UIManager.atParent(hitTarget, _menuTrigger))
				{
					outside = false;
				}
				if (outside)
				{
					hide();
				}
			}
		}

		public function GPanel(data : GPanelData)
		{
			_data = data;
			super(data);
		}

		public function add(value : DisplayObject) : void
		{
			if (!value) return;
			_content.addChild(value);
			if (value is GComponent) GLayout.update(this, GComponent(value));
			reset();
		}

		public function clearContent() : void
		{
			if (!_content) return;
			while (_content.numChildren)
			{
				_content.removeChildAt(0);
			}
			reset();
		}

		public function resetHScrollVisible(value : Boolean) : void
		{
			if (_h_sb) _h_sb.visible=value;			
		}

		public function resetVScrollVisible(value : Boolean) : void
		{
			if (_v_sb) _v_sb.visible=value;
		}

		public function scrollToBottom() : void
		{
			if (_v_sb)
			{
				_v_sb.resetValue(_viewH, 0, _bounds.height - _viewH, _bounds.height - _viewH);
			}
		}

		public function scrollToTop() : void
		{
			if (_v_sb)
			{
				_v_sb.resetValue(_viewH, 0, _bounds.height - _viewH, 0);
			}
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

		public function get padding() : int
		{
			return _data.padding;
		}

		public function set menuTrigger(value : DisplayObject) : void
		{
			_menuTrigger = value;
		}

		public function get v_sb() : GScrollBar
		{
			return _v_sb;
		}

		public function get h_sb() : GScrollBar
		{
			return _h_sb;
		}

		public function get content() : Sprite
		{
			return _content;
		}
	}
}
