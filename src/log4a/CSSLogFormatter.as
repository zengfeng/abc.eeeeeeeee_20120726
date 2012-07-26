package  log4a {
	
	public class CSSLogFormatter implements ILogFormatter {
		public static const cssText : String = ".debug{color:#33FF00}.info{color:#EFEFEF}.warn{color:#00CCFF}.error{color:#FF9900}.fatal{color:#FF66FF}";

		public function CSSLogFormatter() {
		}

		public function format(data : LoggingData, newline : String = "\n") : String {
			var result : String = "<p class='" + data.level.name.toLowerCase() + "'>[" + data.level.name + "]";
			result += data.toString() + "</p>";
			return result;
		}

		public function getColor(name : String) : uint {
			return 0;
		}
	}
}
