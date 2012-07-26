package net {
	import gameui.manager.UIManager;

	public class LibData {
		protected var _url : String;
		protected var _key : String;
		protected var _version : String;
		protected var _cache : Boolean;
		protected var _isRepeat : Boolean;
		public var cls : Class = null;
		public var tryNum : int = 10;

		public function LibData(url : String, key : String = null, cache : Boolean = true, isRepeat : Boolean = true, version : String = "-1", cls : Class = null) {
			_url = url;
			if (key == null) _key = url;
			else _key=key;
			if(version=="-1")
				version = UIManager.version;
			else version = version;
			_version = (version == null ? String(Math.random()) : version);
			_cache = cache;
			_isRepeat = isRepeat;
			this.cls = cls;
		}

		public function get url() : String {
			return _url;
		}

		public function get key() : String {
			return _key;
		}

		public function get version() : String {
			return _version;
		}
		
		public function set version(value:String):void
		{
			if(value=="-1")
				value = UIManager.version;
			else value = version;
			_version=value;
		}

		public function get isCache() : Boolean {
			return _cache;
		}

		public function get isRepeat() : Boolean {
			return _isRepeat;
		}
	}
}
