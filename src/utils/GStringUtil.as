package  utils {
	import flash.utils.ByteArray;

	public class GStringUtil {

		private static function isWhitespace(character : String) : Boolean {
			switch (character) {
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
				default:
					return false;
			}
		}

		public static function trim(str : String) : String {
			if (str == null) return '';
			var startIndex : int = 0;
			while (isWhitespace(str.charAt(startIndex)))
				++startIndex;
			var endIndex : int = str.length - 1;
			while (isWhitespace(str.charAt(endIndex)))
				--endIndex;
			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}

		public static function format(str : String,...rest : Array) : String {
			if (str == null) return '';
			var len : uint = rest.length;
			var args : Array;
			if (len == 1 && rest[0] is Array) {
				args = rest[0] as Array;
				len = args.length;
			} else {
				args = rest;
			}
			for (var i : int = 0;i < len;i++) {
				str = str.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}
			return str;
		}

		public static function byteArrayToString(value : ByteArray) : String {
			var result : String = "";
			for(var i : int = 0;i < value.length;i++) {
				result += Number(value[i]).toString(16) + " ";
			}
			return result;
		}

		public static function filterXML(value : String) : String {
			var result : String = value.replace(/^\s+|\s+$|(\r|\n)/g, "");
			result = result.replace(/\s+/g, " ");
			result = result.replace("&", "&amp;");
			result = result.replace("<", "&lt;");
			result = result.replace(">", "&gt;");
			result = result.replace("\"", "&quot;");
			result = result.replace("\'", "&apos;");
			return result;
		}

		public static function getDwordLength(value : String) : int {
			return value.replace(/[^\x00-\xff]/g, "**").length;
		}

		public static function isEmail(value : String) : Boolean {
			var re : RegExp = /w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/;
			return re.exec(value) != null;
		}

		public static function truncateToFit(value : String,length : int) : String {
			if(length > 0) {
				var a : Array = value.match(/[^\x00-\xff]|\w{1,2}/g);
				return a.length <= length ? value : a.slice(0, length).join("") + "..";
			} else {
				return value;
			}
		}
	}
}