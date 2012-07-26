package gameui.containers
{
	import gameui.core.GComponent;
	import gameui.core.GComponentData;

	import model.GListEvent;
	import model.ListModel;
	import model.ListState;
	import model.SingleSelectionModel;

	import flash.events.Event;



	public class GViewStack extends GComponent {

		protected var _selection : GComponent;

		protected var _selectionModel : SingleSelectionModel;

		protected var _model : ListModel;

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
					updateContent();
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
					updateContent();
					break;
				case ListState.UPDATE:
					break;
				case ListState.INSERT:
					if(event.index <= _selectionModel.index)_selectionModel.index += 1;
					if(_selectionModel.index == -1)_selectionModel.index = 0;
					updateContent();
					break;
			}
		}

		private function selection_changeHandler(event : Event) : void {
			updateContent();
		}

		protected function updateContent() : void {
			if(_selection)_selection.parent.removeChild(_selection);
			var component : GComponent = _model.getAt(_selectionModel.index) as GComponent;
			if(component) {
				addChild(component);
				_width = component.width;
				_height = component.height;
			}
			_selection = component;
		}

		public function GViewStack(base : GComponentData) {
			super(base);
			_selectionModel = new SingleSelectionModel();
			_model = new ListModel();
			addModelEvents();
			_selectionModel.addEventListener(Event.CHANGE, selection_changeHandler);
		}

		public function get selectionModel() : SingleSelectionModel {
			return _selectionModel;
		}

		public function get selection() : GComponent {
			return _model.getAt(_selectionModel.index) as GComponent;
		}

		public function add(component : GComponent) : void {
			_model.add(component);
		}
		
		public function addAt(index:int,component : GComponent) : void {
			_model.insert(index, component);
		}
		
		public function get model():ListModel
		{
			return _model;
		}
	}
}