package  lib
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	public class LIBChunk extends EventDispatcher
	{
		public static const CFG:String="cfg";
		
		public static const SWF:String="swf";
		
		protected var _key:String;
		
		protected var _type:String;
		
		protected var _length:uint;
		
		protected var _data:ByteArray;
				
		public function LIBChunk(key:String,type:String){
			this._key=key;
			this._type=type;
			this._data=new ByteArray();
		}
		
		public function get key():String{
			return this._key;
		}
		
		public function get type():String{
			return this._type;
		}
		
		public function get data():ByteArray{
			return this._data;
		}
		
		public function set data(value:ByteArray):void{
			this._data=value;
		}
		
		public function decode():void{}
	}
}