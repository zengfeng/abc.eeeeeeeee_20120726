package net
{
	import flash.events.EventDispatcher;

	public class ALoader extends EventDispatcher
	{
		internal var completeFun : Function = null;

		internal var errorFun : Function = null;

		protected var _libData : LibData;

		protected var _loadData : LoadData;

		protected var _isLoadding : Boolean = false;

		protected var _isLoaded : Boolean = false;

		public var userNum : int;

		public var funArray : Array = [];

		public function ALoader(data : LibData)
		{
			_libData = data;
			_loadData = new LoadData();
		}

		public function get isLoaded() : Boolean
		{
			return _isLoaded;
		}

		public function get key() : String
		{
			return _libData.key;
		}
		
		public function get url():String
		{
			return _libData.url;
		}

		public function get isCache() : Boolean
		{
			return _libData.isCache;
		}

		public function get isRepeat() : Boolean
		{
			return _libData.isRepeat;
		}

		public function get loadData() : LoadData
		{
			return _loadData;
		}

		public function load() : void
		{
		}

		public function stop() : void
		{
		}

		public function clear() : void
		{
		}
	}
}
