package  log4a {

	/**
	 * @example
	 * Logger.addAppender(new UIAppender(this));
	 * Logger.addAppender(new FireBugAppender());
	 * Logger.addAppender(new LocalAppender());
	 * Logger.setLevel(Level.INFO);
	 * Logger.debug("this is a debug!");
	 * Logger.info("this is a info!");
	 * Logger.warn("this is a warn!");
	 * Logger.error("this is a error!");
	 * Logger.fatal("this is a fatal!"); 
	 * 
	 * Use getInstance() instead.
	 */
	public final class Logger {

		private static var _appenders : Array;

		private static var _level : Level = Level.ALL;
		
		private static var _creating:Boolean=false;

		public function Logger(){
			if(!Logger._creating){
				throw(new Error(this,"Class cannot be instantiated."));
			}
		}

		public static function setLevel(level : Level) : void {
			Logger._level = level;
		}

		public static function addAppender(appender : IAppender) : void {
			if(Logger._appenders == null) {
				Logger._appenders = new Array();
			}
			Logger._appenders.push(appender);
		}
		
		public static function removeAppender():void
		{
			Logger._appenders.pop();
		}

		public static function forcedLog(level : Level,message : Array) : void {
			if(level.compareTo(Logger._level))return;
			Logger.callAppenders(new LoggingData(level,message));
		}

		public static function callAppenders(event : LoggingData) : void {
			for each(var appender:IAppender in Logger._appenders) {
				appender.append(event);
			}
		}

		public static function fatal(...message : Array) : void {
			Logger.forcedLog(Level.FATAL, message);
		}

		public static function error(...message : Array) : void {
			Logger.forcedLog(Level.ERROR, message);
		}

		public static function warn(...message : Array) : void {
			Logger.forcedLog(Level.WARN, message);
		}

		public static function info(...message : Array) : void {
			Logger.forcedLog(Level.INFO, message);
		}

		public static function debug(...message : Array) : void {
			Logger.forcedLog(Level.DEBUG, message);
		}
	}
}