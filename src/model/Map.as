package model
{
	import utils.MathUtil;
	import flash.utils.Dictionary;

	/**
	 * Map
	 */
	public class Map
	{
		public static const ARRAY : int = 0;

		public static const INT : int = 1;

		public static const STRING : int = 2;

		private var _keys : Array;

		private var _values : Dictionary;

		public function Map()
		{
			_keys = new Array();
			_values = new Dictionary(true);
		}

		public function containsKey(key : *) : Boolean
		{
			return _values[key] != null;
		}

		public function containsValue(value : *) : Boolean
		{
			for each (var key:* in _keys)
			{
				if (_values[key] == value) return true;
			}
			return false;
		}

		public function put(key : *, value : *) : void
		{
			if (_values[key] != null)
			{
				_values[key] = value;
			}
			else
			{
				_values[key] = value;
				_keys.push(key);
			}
		}

		public function getBy(key : *) : *
		{
			if (key == null) return null;
			return _values[key];
		}

		public function getAt(index : int) : *
		{
			return _values[_keys[index]];
		}

		public function removeBy(key : *) : int
		{
			if (_values[key] != null)
			{
				delete _values[key];
				var index : int = this._keys.indexOf(key);
				if (index == -1) return -1;
				_keys.splice(index,1);
				return index;
			}
			return -1;
		}

		public function clear() : void
		{
			for each (var key:* in _keys)
			{
				delete _values[key];
			}
			_keys.splice(0);
		}

		public function isEmpty() : Boolean
		{
			return _keys.length < 1;
		}

		public function get size() : uint
		{
			return _keys.length;
		}

		public function get keys() : Array
		{
			return _keys;
		}

		public function get values() : Dictionary
		{
			return _values;
		}

		public function get randomValue() : Object
		{
			return _values[_keys[MathUtil.random(0,_keys.length - 1)]];
		}

		public function sort(value : Function) : void
		{
			_keys.sort(value);
		}

		public function toArray() : Array
		{
			var list : Array = new Array();
			for each (var key:Object in _keys)
			{
				list.push(_values[key]);
			}
			return list;
		}

		public function toString() : String
		{
			var out : String = "";
			for each (var key:* in _keys)
			{
				out += key + "=" + _values[key] + "\n";
			}
			return out;
		}
	}
} 