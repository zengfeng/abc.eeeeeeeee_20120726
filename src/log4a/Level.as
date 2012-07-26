package  log4a
{
	public class Level
	{
		private var _value:int;
		
		private var _name:String;
		
		public static var ALL:Level=new Level(0,"ALL");
		
		public static var DEBUG:Level=new Level(1,"DEBUG");
		
		public static var INFO:Level=new Level(2,"INFO");
		
		public static var WARN:Level=new Level(3,"WARN");
		
		public static var ERROR:Level=new Level(4,"ERROR");
		
		public static var FATAL:Level=new Level(5,"FATAL");
		
		public static var OFF:Level=new Level(6,"OFF");	

		public function Level(value:int=1,name:String="DEBUG")
		{
			_value=value;
			_name=name;
		}
		
		public function get value():int
		{
			return _value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function compareTo(level:Level):Boolean
		{
			return _value<level.value;
		}
	}
}