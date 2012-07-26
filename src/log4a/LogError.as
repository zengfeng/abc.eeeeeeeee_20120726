package  log4a
{
	public class LogError extends Error
	{
		public function LogError(...log:Array)
		{
			super(LoggingData.toCode(log));
			Logger.forcedLog(Level.ERROR,log);
		}
	}
}