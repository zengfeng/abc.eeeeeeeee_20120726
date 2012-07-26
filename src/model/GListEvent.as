package  model {
	import flash.events.Event;

	/**
	 * List Event
	 * 
	 */
	public class GListEvent extends Event {

		public static const CHANGE : String = "listChange";

		private var _state : int;

		private var _index : int;

		private var _item : Object;

		private var _oldItem : Object;		

		public function GListEvent(type : String,state : int,index : int = -1,item : Object = null,oldItem : Object = null) {
			super(type, bubbles, cancelable);
			_state = state;
			_index = index;
			_item = item;
			_oldItem = oldItem;
		}

		public function get state() : int {
			return _state;
		}

		public function get index() : int {
			return _index;
		}

		public function get item() : Object {
			return _item;
		}

		public function get oldItem() : Object {
			return _oldItem;
		}

		override public function clone() : Event {
			return new GListEvent(CHANGE, _state, _index, _item, _oldItem);
		}
	}
}
