package  gameui.controls {
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.group.GToggleGroup;
	public class GToggleBase extends GComponent {

		protected var _selected : Boolean = false;

		protected var _group : GToggleGroup;

		protected function onSelect() : void {
			// this is abstract function
		}

		public function GToggleBase(data : GComponentData) {
			super(data);
		}

		public function set selected(value : Boolean) : void {
			if(_selected == value)return;
			_selected = value;
			if(_group != null && _selected) {
				_group.isSelected(this);
			}
			onSelect();
		}

		public function get selected() : Boolean {
			return _selected;
		}

		public function set group(value : GToggleGroup) : void {
			if(!value)return;
			_group = value;
			_group.model.add(this);			
		}
	}
}