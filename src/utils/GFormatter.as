package  utils {

	public class GFormatter {

		public static function formatDate(value : Date) : String {
			var result : String = value.getFullYear() + "-";
			var month : int = value.getMonth() + 1;
			result += (month > 9) ? month : "0" + month;
			result += "-";
			var date : int = value.getDate();
			result += (date > 9) ? date : "0" + date;
			var hours : int = value.getHours();
			result += " ";
			result += (hours > 9) ? hours : "0" + hours;
			result += ":";
			var minutes : int = value.getMinutes();
			result += (minutes > 9) ? minutes : "0" + minutes;
			result += ":";
			var seconds : int = value.getSeconds();
			result += (seconds > 9) ? seconds : "0" + seconds;
			return result;
		}
	}
}