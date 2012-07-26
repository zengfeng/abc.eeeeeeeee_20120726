package gameui.controls
{
	import gameui.core.GComponent;
	import gameui.data.GScrollBarData;
	import gameui.data.GTextAreaData;
	import gameui.events.GScrollBarEvent;
	import gameui.manager.UIManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * Game Text Area
	 * 
	 */
	public class GTextArea extends GComponent
	{
		protected var _data : GTextAreaData;

		protected var _backgroundSkin : Sprite;

		protected var _textField : TextField;

		protected var _vScrollBar : GScrollBar;

		protected var _hScrollBar : GScrollBar;

		protected var _textWidth : Number;

		protected var _textHeight : Number;

		protected var _lock : Boolean = false;

		override protected function create() : void
		{
			_backgroundSkin = UIManager.getUI(_data.backgroundAsset);
			_textField = UIManager.getTextField();
			_textField.x = _textField.y = _data.padding;
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.condenseWhite = true;
			_textField.maxChars = _data.maxChars;
			_textField.defaultTextFormat = _data.textFormat;
			_textField.textColor = _data.textColor;
			_textField.filters = _data.textFieldFilters;
			if (_data.editable)
			{
				_textField.styleSheet = null;
				_textField.type = TextFieldType.INPUT;
			}
			else
			{
				_textField.type = TextFieldType.DYNAMIC;
				_textField.styleSheet = _data.styleSheet;
			}
			_textField.selectable = _data.selectable;
			var data : GScrollBarData = new GScrollBarData();
			data.parent = this;
			_vScrollBar = new GScrollBar(data);
			data = new GScrollBarData();
			data.direction = GScrollBarData.HORIZONTAL;
			data.visible = false;
			data.parent = this;
			_hScrollBar = new GScrollBar(data);
			if (!_data.hideBackgroundAsset)
				addChild(_backgroundSkin);
			addChild(_textField);
//			addChild(_vScrollBar);
//			addChild(_hScrollBar);
		}

		override protected function layout() : void
		{
			_backgroundSkin.width = _width;
			_backgroundSkin.height = _height;
			_textField.width = _width - _data.padding * 2;
			_textField.height = _height - _data.padding * 2;
			reset();
		}
		
		public function set styleSheet(value : StyleSheet) : void
		{
			_textField.styleSheet = value;
		}

		override protected function onShow() : void
		{
			reset();
			_textField.addEventListener(Event.SCROLL,textFieldScrollHandler);
		}

		override protected function onHide() : void
		{
			_textField.removeEventListener(Event.SCROLL,textFieldScrollHandler);
		}
		
		private var _needHScroll:Boolean=false;
		private var _needVScroll:Boolean=false;
		protected function reset() : void
		{
			_needHScroll = _textField.maxScrollH > 0;
			_needVScroll = vScrollMax > 0;
			var newWidth : int = _width - (_needVScroll ? _vScrollBar.width : 0);
			var newHeight : int = _height - (_needHScroll ? _hScrollBar.height : 0);
			_textField.width = newWidth - _data.padding * 2;
			_textWidth = _textField.textWidth;
			_textField.height = newHeight - _data.padding * 2;
			_textHeight = _textField.textHeight;
			if (_needVScroll)
			{
				_vScrollBar.x = _width - _vScrollBar.width;
				_vScrollBar.height = newHeight;
				_vScrollBar.resetValue(_textField.bottomScrollV - _textField.scrollV + 1,0,vScrollMax,_textField.scrollV - 1);
				if (!_vScrollBar.parent)
				{
					_vScrollBar.addEventListener(GScrollBarEvent.SCROLL,scrollHandler,false,0,true);
					_vScrollBar.show();
				}
			}
			else if (_vScrollBar.parent)
			{
				_vScrollBar.removeEventListener(GScrollBarEvent.SCROLL,scrollHandler,false);
				_vScrollBar.hide();
			}
			if (_needHScroll)
			{
				_hScrollBar.y = _height - _hScrollBar.height;
				_hScrollBar.width = newWidth;
				_hScrollBar.resetValue(_textField.width,0,_textField.maxScrollH,Math.min(_textField.maxScrollH,_textField.scrollH));
				if (!_hScrollBar.parent)
				{
					_hScrollBar.addEventListener(GScrollBarEvent.SCROLL,scrollHandler,false,0,true);
					_hScrollBar.show();
				}
			}
			else if (_hScrollBar.parent)
			{
				_hScrollBar.removeEventListener(GScrollBarEvent.SCROLL,scrollHandler,false);
				_hScrollBar.hide();
			}
		}

		override protected function onEnabled() : void
		{
			_textField.type = (_enabled ? (_data.editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC) : TextFieldType.DYNAMIC);
		}

		protected function get vScrollMax() : int
		{
			var max : int = _textField.numLines - _textField.bottomScrollV + _textField.scrollV - 1;
			return Math.min(max,_textField.maxScrollV - 1);
		}

		protected function scrollHandler(event : GScrollBarEvent) : void
		{
			if (event.direction == GScrollBarData.VERTICAL)
			{
				_textField.scrollV = event.position + 1;
			}
			else
			{
				_textField.scrollH = event.position;
			}
		}

		protected function textFieldScrollHandler(event : Event) : void
		{
			reset();
		}

		public function GTextArea(data : GTextAreaData)
		{
			_data = data;
			super(data);
		}

		public function showEdge(color : uint = 0x000000) : void
		{
			_textField.filters = [new GlowFilter(color,1,2,2,3,1,false,false)];
		}

		public function hideEdge() : void
		{
			_textField.filters = null;
		}

		public function appendHtmlText(value : String) : void
		{
			_textField.htmlText += value;
			if (_data.maxLines > 0)
			{
				var lines : Array = _textField.htmlText.split(_data.edlim);
				if (lines.length - 1 > _data.maxLines)
				{
					_textField.htmlText = _textField.htmlText.slice(String(lines[0]).length + _data.edlim.length);
				}
			}
			if (!_lock)
			{
				_textField.scrollV = vScrollMax + 1;
			}
		}

		public function appendText(value : String, color : uint = 0xCCCCCC) : void
		{
			var begin : int = _textField.text.length;
			_textField.appendText(value);
			_data.textFormat.color = color;
			_textField.setTextFormat(_data.textFormat,begin,_textField.text.length);
			_textField.scrollV = vScrollMax + 1;
		}

		public function set htmlText(value : String) : void
		{
			_textField.htmlText = value;
			if (!_lock)
			{
				_textField.scrollV = vScrollMax + 1;
			}
		}

		public function get htmlText() : String
		{
			return _textField.htmlText;
		}

		public function set text(value : String) : void
		{
			_textField.text = value;
			if (!_lock)
			{
				_textField.scrollV = vScrollMax + 1;
			}
		}

		public function get text() : String
		{
			return _textField.text;
		}

		public function get textField() : TextField
		{
			return _textField;
		}

		public function clear() : void
		{
			_textField.text = "";
		}
		
		public function resetHScrollVisible(value:Boolean):void
		{
			if(_needHScroll)this._hScrollBar.visible=value;
		}
		
		public function resetVScrollVisible(value:Boolean):void
		{
			if(_needVScroll)this._vScrollBar.visible=value;
		}

		public function upScroll() : void
		{
			_lock = true;
			if (_textField.scrollV > 0)
			{
				_textField.scrollV--;
			}
		}

		public function downScroll() : void
		{
			_lock = true;
			if (_textField.scrollV < vScrollMax + 1)
			{
				_textField.scrollV++;
			}
		}

		public function scrollToBottom() : void
		{
			_lock = false;
			_textField.scrollV = vScrollMax + 1;
		}
		
		public function scrollToTop() : void
		{
			_lock = false;
			_textField.scrollV = 0;
		}
	}
}
