package gameui.controls
{
	import gameui.core.GComponent;
	import gameui.data.GSpinnerData;

	import model.GListEvent;
	import model.ListModel;
	import model.ListState;
	import model.SingleSelectionModel;

	import flash.events.Event;
	import flash.events.MouseEvent;



	public class GSpinner extends GComponent {

		protected var _data : GSpinnerData;

		protected var _upArrow : GButton;

		protected var _downArrow : GButton;

		protected var _textInput : GTextInput;

		protected var _selectionModel : SingleSelectionModel;

		protected var _model : ListModel;

		override protected function create() : void {
			_upArrow = new GButton(_data.upArrowData);
			_downArrow = new GButton(_data.downArrowData);
			_downArrow.y = _upArrow.height;
			_textInput = new GTextInput(_data.textInputData);
			addChild(_upArrow);
			addChild(_downArrow);
			addChild(_textInput);
		}

		override protected function layout() : void {
			_upArrow.x = _width - _upArrow.width;
			_downArrow.x = _width - _downArrow.width;
			_textInput.width = _width - _upArrow.width;
		}

		protected function addModelEvents() : void {
			_model.addEventListener(GListEvent.CHANGE, model_changeHandler);
		}

		protected function removeModelEvents() : void {
			_model.removeEventListener(GListEvent.CHANGE, model_changeHandler);
		}

		protected function model_changeHandler(event : GListEvent) : void {
			var index : int = event.index;
			switch(event.type) {
				case ListState.RESET:
					if(_selectionModel.index >= _model.size)_selectionModel.index = 0;
					updateContent();
					break;
				case ListState.ADDED:
					break;
				case ListState.REMOVED:
					if(index < _selectionModel.index) {
						_selectionModel.index -= 1;
					}else if(index == _selectionModel.index) {
						_selectionModel.index = -1;
					}
					if(_selectionModel.index == -1)_selectionModel.index = 0;
					updateContent();
					break;
				case ListState.UPDATE:
					break;
				case ListState.INSERT:
					if(index <= _selectionModel.index)_selectionModel.index += 1;
					if(_selectionModel.index == -1)_selectionModel.index = 0;
					updateContent();
					break;
			}
		}

		private function selection_changeHandler(event : Event) : void {
			updateContent();
		}

		protected function updateContent() : void {
			var value : Object = _model.getAt(_selectionModel.index);
			if(value) {
				_textInput.text = String(value);
			} else {
				_textInput.clear();
			}
		}

		protected function initEvents() : void {
			_upArrow.addEventListener(MouseEvent.CLICK, up_clickHandler);
			_downArrow.addEventListener(MouseEvent.CLICK, down_clickHandler);
			addModelEvents();
			_selectionModel.addEventListener(Event.CHANGE, selection_changeHandler);
		}

		protected function up_clickHandler(event : MouseEvent) : void {
			if(_selectionModel.index < _model.size - 1) {
				_selectionModel.index++;
			}
		}

		protected function down_clickHandler(event : MouseEvent) : void {
			if(_selectionModel.index > 0) {
				_selectionModel.index--;
			}
		}

		public function GSpinner(data : GSpinnerData) {
			_data = data;
			super(_data);
			_selectionModel = new SingleSelectionModel();
			_model = new ListModel();
			initEvents();
		}

		public function get selectionModel() : SingleSelectionModel {
			return _selectionModel;
		}

		public function set selectionModel(value : SingleSelectionModel) : void {
			if(_selectionModel == value)return;
			if(_selectionModel)_selectionModel.removeEventListener(Event.CHANGE, selection_changeHandler);
			_selectionModel = value;
			_selectionModel.addEventListener(Event.CHANGE, selection_changeHandler);
			updateContent();
		}

		public function set model(value : ListModel) : void {
			if(_model === value)return;
			if(_model)removeModelEvents();
			_model = value;
			addModelEvents();
			updateContent();
		}
	}
}
