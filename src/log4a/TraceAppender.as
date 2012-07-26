package  log4a {
	public class TraceAppender extends Appender {
		public function TraceAppender() {
			super();
			_formatter = new SimpleLogFormatter();
		}

		override public function append(data : LoggingData) : void {
			var message : String = _formatter.format(data, "");
			trace(message);
		}
	}
}