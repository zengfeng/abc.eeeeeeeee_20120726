package  log4a
{
	public interface ILogFormatter
	{
		function format(data:LoggingData,newline:String="\n"):String;
		
		function getColor(name:String):uint;
	}
}