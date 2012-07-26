package gameui.controls
{
	import gameui.core.GComponent;
	import gameui.data.GTextInputData;
	import gameui.manager.UIManager;

	import utils.GStringUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	/**
	 * Game Text Input
	 * 
	 */
	public class GTextInput extends GComponent
	{
		public static const ENTER : String = "enter";
		protected var _data : GTextInputData;
		protected var _borderSkin : Sprite;
		protected var _disabledSkin : Sprite;
		protected var _textField : TextField;
		protected var _hintTextField : TextField;
		protected var _current : Sprite;

		override protected function create() : void
		{
			_borderSkin = UIManager.getUI(_data.borderAsset);
			_disabledSkin = UIManager.getUI(_data.disabledAsset);
			_current = _borderSkin;
			_textField = UIManager.getInputTextField();
			_textField.defaultTextFormat = _data.textFormat;
			_textField.condenseWhite = true;
			_textField.textColor = _data.textColor;
			_textField.filters = _data.textFieldFilters;
			_textField.maxChars = _data.maxChars;
			_textField.displayAsPassword = _data.displayAsPassword;

			_textField.wordWrap = _data.wordWrap;
			if (_data.restrict.length > 0)
			{
				_textField.restrict = _data.restrict;
			}
			_textField.text = _data.text;
			_textField.x = _data.indent;
			addChild(_borderSkin);
			addChild(_textField);

			if (_data.hintText)
			{
				_hintTextField = new TextField();
				_hintTextField.mouseEnabled = false;
				_hintTextField.defaultTextFormat = _data.textFormat;
				_hintTextField.textColor = _data.disabledColor;
				_hintTextField.text = _data.hintText;
				if (_data.text)
					_hintTextField.visible = false;
				addChild(_hintTextField);
			}
		}

		override public function set enabled(value : Boolean) : void
		{
			super.enabled = value;

			updateHintText();
		}

		override protected function layout() : void
		{
			_borderSkin.width = _width;
			_borderSkin.height = _height;
			_disabledSkin.width = _width;
			_disabledSkin.height = _height;
			_textField.height = _height - 6;
//			_textField.y = Math.floor((_height - _textField.textHeight) / 2);
			_textField.y = 4;
			_textField.width = _width - _data.indent - 1;
			if (_hintTextField)
			{
				_hintTextField.x = _textField.x;
				_hintTextField.y = _textField.y;
				_hintTextField.width = _textField.width;
				_hintTextField.height = _textField.height;
			}
		}

		override protected function onEnabled() : void
		{
			if (_enabled)
			{
				swap(_current, _borderSkin);
				_current = _borderSkin;
				_textField.textColor = _data.textColor;
			}
			else
			{
				swap(_current, _disabledSkin);
				_current = _disabledSkin;
				_textField.textColor = _data.disabledColor;
			}
		}

		override protected function onShow() : void
		{
			if (Capabilities.hasIME)
			{
				IME.enabled = _data.allowIME;
			}
			_textField.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			if (_data.maxChars > 0)
			{
				_textField.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			}
			_textField.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			_textField.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			if (_data.wordWrap)
				_textField.addEventListener(Event.CHANGE, changeHandler);
			if (_data.selectAll)
				_textField.addEventListener(MouseEvent.CLICK, selectAllOnce);
		}

		override protected function onHide() : void
		{
			_textField.removeEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			if (_data.maxChars > 0)
			{
				_textField.removeEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			}
			_textField.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			_textField.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			if (_data.wordWrap)
				_textField.removeEventListener(Event.CHANGE, changeHandler);
			if (_data.selectAll)
				_textField.removeEventListener(MouseEvent.CLICK, selectAllOnce);
			if (Capabilities.hasIME)
			{
				IME.enabled = false;
			}
			if (stage.focus == _textField)
			{
				stage.focus = null;
			}
		}
		
		public function checkInput():void
		{
			if(_data.restrict!=GTextInputData.NUM_RESTRICT||_data.hintText)return;
			if(_data.numFun!=null)_data.maxNum=_data.numFun();
			if(_textField.text=="")return;
			if(int(_textField.text)<_data.minNum)_textField.text=String(_data.minNum);
			if(int(_textField.text)>_data.maxNum)_textField.text=String(_data.maxNum);
		}

		public function set textColor(color : uint) : void
		{
			_data.textColor = color;
			if (_enabled)
			{
				_textField.textColor = _data.textColor;
			}
		}

		public function set disabledColor(color : uint) : void
		{
			_data.disabledColor = color;
			if (!_enabled)
			{
				_textField.textColor = _data.disabledColor;
			}
		}

		private function textInputHandler(event : TextEvent) : void
		{
			if (_data.maxChars > 0 && GStringUtil.getDwordLength(_textField.text) - GStringUtil.getDwordLength(_textField.selectedText) >= _data.maxChars)
			{
				event.preventDefault();
				return;
			}
			event.stopImmediatePropagation();
			var newEvent : TextEvent = new TextEvent(TextEvent.TEXT_INPUT, false, true);
			newEvent.text = event.text;
			dispatchEvent(newEvent);
			if (newEvent.isDefaultPrevented()) event.preventDefault();
		}

		private function focusInHandler(event : FocusEvent) : void
		{
			updateHintText();
			if (Capabilities.hasIME)
			{
				IME.enabled = _data.allowIME;
			}
			dispatchEvent(event);
		}

		private function focusOutHandler(event : FocusEvent) : void
		{
			updateHintText();
			checkInput();
			if (Capabilities.hasIME)
			{
				IME.enabled = false;
			}
			if (_data.selectAll)
				_textField.addEventListener(MouseEvent.CLICK, selectAllOnce);
			dispatchEvent(event);
		}

		private function keyDownHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				if (stage.focus == _textField)
				{
					dispatchEvent(new Event(GTextInput.ENTER));
				}
			}
		}

		public function changeHandler(event : Event) : void
		{
			layout();
		}

		public function GTextInput(data : GTextInputData)
		{
			_data = data;
			super(data);
		}

		public function selectAll() : void
		{
			if (_textField.text.length < 1) return;
			_textField.setSelection(0, _textField.getLineLength(0));
		}

		public function setFocus(focus : Boolean = true) : void
		{
			if (focus)
			{
				if (UIManager.stage.focus != _textField)
				{
					UIManager.stage.focus = _textField;
				}
			}
			else
			{
				if (UIManager.stage.focus == _textField)
				{
					UIManager.stage.focus = null;
				}
			}
		}

		public function isFocus() : Boolean
		{
			return UIManager.stage.focus == _textField;
		}

		public function set text(value : String) : void
		{
			_textField.text = value;
			updateHintText();
		}

		public function set htmlText(value : String) : void
		{
			_textField.htmlText = value;
			updateHintText();
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

		private function selectAllOnce(e : MouseEvent) : void
		{
			_textField.removeEventListener(MouseEvent.CLICK, selectAllOnce);
			selectAll();
		}

		private function updateHintText() : void
		{
			if (_hintTextField)
				_hintTextField.visible = (!isFocus() && (text == "") && enabled);
		}
	}
}
