package  utils
{
	import flash.utils.getQualifiedClassName;
	
	public class GNameUtil
	{
		private static var _counter:int=0;
		
		public static function createUniqueName(object:Object):String{
			if(!object)return null;
			var name:String=getQualifiedClassName(object);
			var index:int=name.indexOf("::");
			if (index!=-1)name=name.substr(index+2);
			var charCode:int=name.charCodeAt(name.length-1);
			if(charCode>=48&&charCode<= 57)name+="_";
			return name+_counter++;
		}
		
		public static function getUnqualifiedClassName(object:Object):String{
			var name:String;
			if(object is String)name=object as String;
			else name=getQualifiedClassName(object);
			var index:int=name.indexOf("::");
			if(index!=-1)name=name.substr(index+2);
			return name;
		}
	}
}