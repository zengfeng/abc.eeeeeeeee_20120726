package gameui.controls
{
	import gameui.core.GComponent;
	import gameui.data.GComboBoxData;
	import gameui.manager.UIManager;

	import model.ListModel;
	import model.SelectionModel;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class GComboBox extends GComponent
	{
		protected var _data : GComboBoxData;

		protected var _button : GButton;

		protected var _textInput : GTextInput;

		protected var _arrow : GButton;

		protected var _list : GList;

		protected var _editable : Boolean;

		override protected function create() : void
		{
			_button = new GButton(_data.buttonData);
			_textInput = new GTextInput(_data.textInputData);
			_arrow = new GButton(_data.arrow);
			_list = new GList(_data.listData);
			_editable = _data.editable;
			if (_editable)
			{
				addChild(_textInput);
			}
			else
			{
				addChild(_button);
			}
		}

		override protected function layout() : void
		{
			_button.setSize(_width, _height);
			_textInput.width = _width - _arrow.width;
			_arrow.x = _width - _arrow.width;
		}

		protected function clickHandler(event : MouseEvent) : void
		{
			if (_list.parent)
			{
				_list.parent.removeChild(_list);
			}
			else
			{
				showList();
			}
		}

		public function showList() : void
		{
			var global : Point = localToGlobal(new Point(0, _height));
			_list.moveTo(global.x, global.y);
			UIManager.root.addChild(_list);
		}
		
		public function hideList() : void
		{
			if (_list.parent)
			{
				_list.parent.removeChild(_list);
			}
		}

		override protected function onShow() : void
		{
			_button.addEventListener(MouseEvent.CLICK, clickHandler);
			_arrow.addEventListener(MouseEvent.CLICK, clickHandler);
			if (_editable)
			{
				_textInput.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
				_textInput.addEventListener(Event.CHANGE,textInputChange);
			}
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
		}

		override protected function onHide() : void
		{
			_list.hide();
			_button.removeEventListener(MouseEvent.CLICK, clickHandler);
			_arrow.removeEventListener(MouseEvent.CLICK, clickHandler);
			if (_editable)
			{
				_textInput.removeEventListener(TextEvent.TEXT_INPUT, textInputHandler);
				_textInput.removeEventListener(Event.CHANGE,textInputChange);
			}
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
		}

		protected function textInputHandler(event : TextEvent) : void
		{
			dispatchEvent(event);
		}

		protected function textInputChange(event:Event) : void
		{
			dispatchEvent(event);
		}
		
		public function get textInputText():String
		{
			if (_editable)
			{
				return _textInput.text;
			}
			return "";
		}
		
		public function set textInputText(value:String):void
		{
			if (_editable)
			{
				 _textInput.htmlText = value;
			}
		}

		private function stage_mouseDownHandler(event : MouseEvent) : void
		{
			var target : DisplayObject = event.target as DisplayObject;
			if (UIManager.atParent(target, _list)) return;
			if (UIManager.atParent(target, this)) return;
			_list.hide();
		}

		private function selectHandler(event : Event) : void
		{
			if (_list.selectionModel.isSelected)
			{
				var value : Object = _list.selection;
				if (value)
				{
					if (_editable)
					{
						_textInput.htmlText = String(value);
					}
					else
					{
						_button.htmlText = String(value);
					}
				}
			}
			_list.hide();
		}

		public function GComboBox(data : GComboBoxData)
		{
			_data = data;
			super(_data);
			_list.selectionModel.addEventListener(Event.CHANGE, selectHandler);
		}
		
		public function get textInput():GTextInput
		{
			return _textInput;
		}

		public function get model() : ListModel
		{
			return _list.model;
		}

		public function get selectionModel() : SelectionModel
		{
			return _list.selectionModel;
		}

		public function set listWidth(value : int) : void
		{
			_list.width = value;
		}

		public function get list() : GList
		{
			return _list;
		}
	}
}
