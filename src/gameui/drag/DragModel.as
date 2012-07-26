package  gameui.drag {
	public class DragModel {
		private  var _list : Array;

		public function DragModel() {
			_list = new Array();
		}

		public function add(target : IDragTarget) : void {
			_list.push(target);
		}

		public function remove(target : IDragTarget) : void {
			var index : int = _list.indexOf(target);
			if (index != -1) _list.splice(index, 1);
		}

		public function check(dragData : DragData) : Boolean {
			if (_list.length == 0) return false;
			for each (var target:IDragTarget in _list) {
				if (target == dragData.owner) continue;
				if (target.dragEnter(dragData)) return true;
			}
			return false;
		}
	}
}
