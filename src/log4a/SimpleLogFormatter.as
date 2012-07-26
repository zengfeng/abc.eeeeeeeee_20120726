package  log4a {
	import flash.utils.Dictionary;
	
	public final class SimpleLogFormatter implements ILogFormatter
	{
		private var _colors:Dictionary;
		
		public function SimpleLogFormatter(){
			_colors=new Dictionary(true);
			_colors["DEBUG"]=0x33FF00;
			_colors["INFO"]=0xEFEFEF;
			_colors["WARN"]=0x00CCFF;
			_colors["ERROR"]=0xFF9900;
			_colors["FATAL"]=0xFF66FF;
		}
		
		public function format(data:LoggingData,newline:String="\n"):String{
			var result:String="["+data.level.name+"]";
			result+=data.toString()+newline;
			return result;
		}
		
		public function getColor(name:String):uint{
			return _colors[name];
		}
	}
}