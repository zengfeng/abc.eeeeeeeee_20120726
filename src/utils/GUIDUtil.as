package  utils {
	import flash.utils.ByteArray;

	public class GUIDUtil {

		private static const ALPHA_CHAR_CODES : Array = [48, 49, 50, 51, 52, 53, 54, 
			55, 56, 57, 65, 66, 67, 68, 69, 70];

		private static function getDigit(hex : String) : uint {
			switch (hex) {
				case "A": 
				case "a":           
					return 10;
				case "B":
				case "b":
					return 11;
				case "C":
				case "c":
					return 12;
				case "D":
				case "d":
					return 13;
				case "E":
				case "e":
					return 14;                
				case "F":
				case "f":
					return 15;
				default:
					return new uint(hex);
			}    
		}

		public static function createUID() : String {
			var uid : Array = new Array(36);
			var index : int = 0;
			var i : int;
			var j : int;
			for (i = 0;i < 8;i++) {
				uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
			}
			for (i = 0;i < 3;i++) {
				uid[index++] = 45;
				for (j = 0;j < 4;j++) {
					uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
				}
			}
			uid[index++] = 45;
			var time : Number = new Date().getTime();
			var timeString : String = ("0000000" + time.toString(16).toUpperCase()).substr(-8);
			for (i = 0;i < 8;i++) {
				uid[index++] = timeString.charCodeAt(i);
			}
			for (i = 0;i < 4;i++) {
				uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
			}
			return String.fromCharCode.apply(null, uid);
		}

		public static function isUID(value : String) : Boolean {
			if(value.length != 36)return false;
			var re : RegExp = /^[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}$/;
			return re.exec(value) != null;
		}

		public static function toByteArray(uid : String) : ByteArray {
			if (isUID(uid)) {
				var result : ByteArray = new ByteArray();
				for (var i : uint = 0;i < uid.length;i++) {
					var c : String = uid.charAt(i);
					if (c == "-")
						continue;
					var h1 : uint = getDigit(c);
					i++;
					var h2 : uint = getDigit(uid.charAt(i));
					result.writeByte(((h1 << 4) | h2) & 0xFF);
				}
				result.position = 0;
				return result;
			}
			return null;
		}
	}
}