package  net {
	/**
	 * Asset Data
	 */
	public class AssetData {
		public static const AS_LIB : String = "asLib";
		public static const SWF_LIB : String = "ui";
		protected var _className : String;
		protected var _libId : String;

		public function AssetData(className : String, theme : String = SWF_LIB) {
			_className = className;
			_libId = theme;
		}

		public function get className() : String {
			return _className;
		}

		public function get libId() : String {
			return _libId;
		}

		public function get key() : String {
			return _className + "_" + _libId;
		}
	}
}
