package model
{
	import gameui.drag.IDragItem;

	import flash.events.Event;
	import flash.events.EventDispatcher;


	/**
	 * List Model
	 * 
	 */
	public class ListModel extends EventDispatcher {

		private var _allowNull : Boolean;

		private var _fireEvent : Boolean;

		private var _max : int;

		private var _place : int;

		private var _source : Array;

		private var _oldSource : Array;

		private var _sortFun : Function;

		public function ListModel(allowNull : Boolean = false,max : int = 0,place : int = -1) {
			_allowNull = allowNull;
			_max = max;
			_place = place;
			_fireEvent = true;
			_source = new Array();
		}

		public function set allowNull(value : Boolean) : void {
			_allowNull = value;
		}

		public function get allowNull() : Boolean {
			return _allowNull;
		}

		public function set fireEvent(value : Boolean) : void {
			_fireEvent = value;
		}

		public function set max(value : int) : void {
			value = Math.max(0, value);
			if(_max == value)return;
			_max = value;
			if(size > _max)_source.splice(_max);
			dispatchEvent(new Event(Event.RESIZE));
		}

		public function get max() : int {
			return _max;
		}

		public function set place(value : int) : void {
			_place = value;
		}

		public function get place() : int {
			return _place;
		}

		public function set source(value : Array) : void {
			_oldSource = _source.concat();
			if(value == null) {
				if(_source.length > 0) {
					_source.splice(0);
				}
			} else {
				_source = value;
				if(_max > 0 && size > _max) {
					_source.splice(_max);
				}
				if(_allowNull) {
					for(var i : int = 0;i < _source.length;i++) {
						var item : IDragItem = _source[i] as IDragItem;
						if(item != null) {
							item.place = _place;
							item.gird = i;
						}
					}
				}
			}
			dispatchEvent(new Event(Event.RESIZE));
			if(_fireEvent)dispatchEvent(new GListEvent(GListEvent.CHANGE, ListState.RESET));
		}

		public function get source() : Array {
			return _source;
		}

		public function get oldSource() : Array {
			return _oldSource;
		}

		public function set sortFun(value : Function) : void {
			_sortFun = value;
		}

		public function sort() : void {
			if(_sortFun != null) {
				_source.sort(_sortFun);
				if(_fireEvent) {
					dispatchEvent(new GListEvent(GListEvent.CHANGE, ListState.RESET));
				}
			}
		}

		public function clear() : void {
			_oldSource = _source.concat();
			_source.splice(0);
			if(_fireEvent)dispatchEvent(new GListEvent(GListEvent.CHANGE, ListState.RESET));
		}

		public function add(item : Object) : void {
			if(item == null)return;
			var index : int;
			if(_allowNull) {
				index = findFree();
				if(index == -1)return;
				setAt(index, item);
			} else {
				if(_max > 0 && _source.length >= _max)return;
				index = _source.push(item) - 1;
				dispatchEvent(new Event(Event.RESIZE));
				if(_fireEvent)dispatchEvent(new GListEvent(GListEvent.CHANGE, ListState.ADDED, index, item));
			}
		}

		public function insert(index : int,item : Object) : void {
			if(index < 0 || index > size)return;
			if(_allowNull) {
				setAt(index, item);
			} else {
				if(_max > 0 && size >= _max)return;	
				_source.splice(index, 0, item);
				dispatchEvent(new Event(Event.RESIZE));
				if(_fireEvent)dispatchEvent(new GListEvent(GListEvent.CHANGE, ListState.INSERT, index, item));
			}
		}

		public function remove(item : Object) :int {
			var index : int = _source.indexOf(item);
			if(index != -1)removeAt(index);
			return index;
		}

		public function removeAt(index : int) : void {
			if(index < 0 || index >= size)return;
			if(_allowNull) {
				setAt(index, null);
			} else {
				var item : Object = _source.splice(index, 1)[0];
				dispatchEvent(new Event(Event.RESIZE));
				if(_fireEvent)dispatchEvent(new GListEvent(GListEvent.CHANGE, ListState.REMOVED, index, null, item));
			}
		}

		public function setAt(index : int,item : Object) : void {
			if(_max > 0 && index >= _max) {
				return;
			}
			var oldItem : Object;
			if(_allowNull) {
				if(_source[index] == item) {
					return;
				}
				oldItem = _source[index];
				_source[index] = item;
				if(item is IDragItem) {
					item["place"] = _place;
					item["gird"] = index;
				}
				if(_fireEvent) {
					dispatchEvent(new GListEvent(GListEvent.CHANGE, ListState.UPDATE, index, item, oldItem));
				}
			} else {
				if(index < 0 || index > _source.length) {
					return;
				}
				if(_source[index] == item)return;
				oldItem = _source[index];
				if(item != null) {
					_source[index] = item;
					if(_fireEvent) {
						dispatchEvent(new GListEvent(GListEvent.CHANGE, oldItem == null ? ListState.ADDED : ListState.UPDATE, index, item, oldItem));
					}
				} else {
					removeAt(index);
				}
			}
		}

		public function getAt(index : uint) : Object {
			return _source[index];
		}

		public function getLast() : Object {
			return _source[size - 1];
		}

		public function indexOf(value : Object) : int {
			return _source.indexOf(value);
		}

		public function findAt(key : String,value : Object) : int {
			for(var index : int = 0;index < _source.length;index++) {
				var item : Object = _source[index];
				if(item != null && item.hasOwnProperty(key) && item[key] == value) {
					return index;
				}
			}
			return -1;
		}

		public function findFree() : int {
			if(_allowNull) {
				for(var index : int = 0;index < _source.length;index++) {
					if(_source[index] == null) {
						break;
					}
				}
				if(_max > 0 && index >= _max) {
					return -1;
				}
				return index;
			} else {
				if(_max > 0) {
					if(_source.length < _max) {
						return _source.length;
					} else {
						return -1;
					}
				} else {
					return _source.length;
				}
			}
		}

		public function update(index : int = -1) : void {
			if(index != -1) {
				if(isValid(index)) {
					if(_fireEvent) {
						dispatchEvent(new GListEvent(GListEvent.CHANGE, ListState.UPDATE, index, getAt(index)));	
					}
				}
			} else {
				if(_fireEvent) {
					dispatchEvent(new GListEvent(GListEvent.CHANGE, ListState.RESET));
				}
			}
		}

		public function isValid(index : int) : Boolean {
			if(index < 0)return false;
			if(_max > 0) {
				if(index >= max)return false;
			} else {
				if(index >= size)return false;
			}
			return true;
		}

		public function get size() : int {
			return _source.length;
		}

		public function get validSize() : int {
			if(_allowNull) {
				var size : int = 0;
				for(var index : int = 0;index < _source.length;index++) {
					if(_source[index] != null) {
						size++;
					}
				}
				return size;
			} else {
				return _source.length;
			}
		}

		public function get freeSize() : int {
			if(_allowNull) {
				if(_max > 0) {
					return _max - validSize;
				} else {
					return 0;
				}
			} else {
				return 0;
			}
		}

		public function toArray() : Array {
			return _source.concat();
		}

		public function toTrimArray() : Array {
			if(_allowNull) {
				var list : Array = new Array();
				for(var index : int = 0;index < _source.length;index++) {
					if(_source[index] != null) {
						list.push(_source[index]);
					}
				}
				return list;
			} else {
				return _source.concat();
			}
		}
	}
}
