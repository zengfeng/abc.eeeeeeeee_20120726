package  lib {
	import flash.utils.ByteArray;
	
	public class LIBEncoder
	{
		private var _chunks:Array;
		
		public function LIBEncoder(){
			this._chunks=new Array();
		}
		
		public function add(chunk:LIBChunk):void{
			this._chunks.push(chunk);
		}
		
		public function removeAll():void{
			this._chunks=new Array();
		}
		
		public function encode():ByteArray{
			var libs:ByteArray=new ByteArray();
			for each(var chunk:LIBChunk in this._chunks){
				libs.writeUTF(chunk.key);
				libs.writeUTF(chunk.type);
				libs.writeUnsignedInt(chunk.data.length);
				libs.writeBytes(chunk.data);
			}
			return libs;
		}
	}
}