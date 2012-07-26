package gameui.controls
{
	import gameui.core.GComponent;
	import gameui.data.GStepperData;

	import model.RangeModel;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;



	/**
	 * Game Stepper
	 * 
	 */
	public class GStepper extends GComponent {

		protected var _data : GStepperData;

		protected var _upArrow : GButton;

		protected var _downArrow : GButton;

		protected var _textInput : GTextInput;

		protected var _model : RangeModel;

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
			_model.addEventListener(Event.CHANGE, model_changeHandler);
		}

		protected function removeModelEvents() : void {
			_model.removeEventListener(Event.CHANGE, model_changeHandler);
		}

		protected function model_changeHandler(event : Event) : void {
			_textInput.text = String(_model.value);
		}

		protected function initEvents() : void {
			_textInput.addEventListener(GTextInput.ENTER, enterHandler);
			_textInput.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			_upArrow.addEventListener(MouseEvent.CLICK, up_clickHandler);
			_downArrow.addEventListener(MouseEvent.CLICK, down_clickHandler);
			addModelEvents();
		}

		protected function enterHandler(event : Event) : void {
			var value : Number = Number(_textInput.text);
			if(isNaN(Number(value))) {
				_textInput.text = String(_model.value);
			} else {
				_model.value = value;
			}
		}

		protected function focusOutHandler(event : Event) : void {
			var value : Number = Number(_textInput.text);
			if(isNaN(Number(value))) {
				_textInput.text = String(_model.value);
			} else {
				_model.value = value;
			}
		}

		protected function up_clickHandler(event : MouseEvent) : void {
			if(_model.value < _model.max) {
				_model.value++;
			}
		}

		protected function down_clickHandler(event : MouseEvent) : void {
			if(_model.value > _model.min) {
				_model.value--;
			}
		}

		public function GStepper(data : GStepperData) {
			_data = data;
			super(_data);
			_model = new RangeModel();
			_textInput.text = String(_model.value);
			initEvents();
		}

		public function get model() : RangeModel {
			return _model;
		}

		public function set model(value : RangeModel) : void {
			if(_model === value)return;
			if(_model != null) {
				removeModelEvents();
			}
			_model = value;
			_textInput.text = String(_model.value);
			addModelEvents();
		}
	}
}
