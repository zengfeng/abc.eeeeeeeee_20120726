package  log4a
{
	public class Appender implements IAppender
	{
		protected var _formatter:ILogFormatter;
		
		public function Appender(){
		}
		
		public function append(event:LoggingData):void{
		}
	}
}