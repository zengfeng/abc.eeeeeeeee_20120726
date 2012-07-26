package gameui.controls
{
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.data.GSelectorData;
	import gameui.layout.GLayout;

	import model.GListEvent;
	import model.ListModel;
	import model.ListState;
	import model.SelectionModel;

	import flash.events.Event;
	import flash.events.MouseEvent;



	public class GSelector extends GComponent {

		protected var _data : GSelectorData;

		protected var _label : GLabel;

		protected var _prev_btn : GButton;

		protected var _next_btn : GButton;

		protected var _content : GComponent;

		protected var _selectionModel : SelectionModel;

		protected var _model : ListModel;

		override protected function create() : void {
			var left : int = 0;
			if(_data.labelData) {
				_data.labelData.align = new GAlign(-1, -1, -1, -1, -1, 0);
				_label = new GLabel(_data.labelData);
				left = _label.width;
				addChild(_label);
			}
			_data.prev_buttonData.align = new GAlign(left, -1, -1, -1, -1, 0);
			addButtons();
			addContent();
		}

		private function addButtons() : void {
			_prev_btn = new GButton(_data.prev_buttonData);
			addChild(_prev_btn);
			_next_btn = new GButton(_data.next_buttonData);
			addChild(_next_btn);
		}

		private function addContent() : void {
			_content = new _data.content(_data.componentData);
			addChild(_content);
		}

		override protected function layout() : void {
			if(_label)GLayout.layout(_label);
			GLayout.layout(_prev_btn);
			GLayout.layout(_next_btn);
			layoutContent();
		}

		private function layoutContent() : void {
			var labelWidth : int = (_label ? _label.width : 0);
			_content.x = labelWidth + Math.floor((_width - labelWidth - _content.width) / 2);
			_content.y = Math.floor((_height - _content.height) / 2);
		}

		private function prevHandler(event : Event) : void {
			if(_selectionModel.index > 0) {
				_selectionModel.index--;
			} else {
				_selectionModel.index = _model.size - 1;
			}
		}

		private function nextHandler(event : Event) : void {
			if(_selectionModel.index < _model.size - 1) {
				_selectionModel.index++;
			} else {
				_selectionModel.index = 0;
			}
		}

		protected function addModelEvents() : void {
			_model.addEventListener(GListEvent.CHANGE, model_changeHandler);
		}

		protected function removeModelEvents() : void {
			_model.removeEventListener(GListEvent.CHANGE, model_changeHandler);
		}

		protected function model_changeHandler(event : GListEvent) : void {
			switch(event.state) {
				case ListState.RESET:
					if(_selectionModel.index >= _model.size)_selectionModel.index = 0;
					reset();
					break;
				case ListState.ADDED:
					break;
				case ListState.REMOVED:
					if(event.index < _selectionModel.index) {
						_selectionModel.index -= 1;
					}else if(event.index == _selectionModel.index) {
						_selectionModel.index = -1;
					}
					if(_selectionModel.index == -1)_selectionModel.index = 0;
					reset();
					break;
				case ListState.UPDATE:
					break;
				case ListState.INSERT:
					if(event.index <= _selectionModel.index)_selectionModel.index += 1;
					if(_selectionModel.index == -1)_selectionModel.index = 0;
					reset();
					break;
			}
		}

		private function selection_changeHandler(event : Event) : void {
			reset();
		}

		private function reset() : void {
			_content.source = _model.getAt(_selectionModel.index);
			layoutContent();
		}

		override protected function onEnabled() : void {
			_prev_btn.enabled = _enabled;
			_next_btn.enabled = _enabled;
		}

		public function GSelector(data : GSelectorData) {
			_data = data;
			super(data);
			_prev_btn.addEventListener(MouseEvent.CLICK, prevHandler);
			_next_btn.addEventListener(MouseEvent.CLICK, nextHandler);
			_selectionModel = new SelectionModel();
			_selectionModel.addEventListener(Event.CHANGE, selection_changeHandler);
			_model = new ListModel();
			addModelEvents();
			_selectionModel.addEventListener(Event.CHANGE, selection_changeHandler);
		}

		public function get selectionModel() : SelectionModel {
			return _selectionModel;
		}

		public function get model() : ListModel {
			return _model;
		}

		public function get selection() : Object {
			return _model.getAt(_selectionModel.index);
		}
	}
}
