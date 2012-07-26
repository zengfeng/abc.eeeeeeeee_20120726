package lib
{
	import log4a.LogError;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	
	public class LIBDecoder extends EventDispatcher
	{
		private static var _chunks:Dictionary=new Dictionary(true);
		
		private var _lib:ByteArray;
		
		private var _list:Array;
		
		private function readChunks():void{
			this._lib.position=0;
			this._list=new Array();
			while(this._lib.position<this._lib.length){
				var key:String=this._lib.readUTF();
				var type:String=this._lib.readUTF();
				var chunk:LIBChunk;
				switch(type){
					case LIBChunk.CFG:
						chunk=new CFGChunk(key);
						break;
					case LIBChunk.SWF:
						chunk=new SWFChunk(key);
						break;
				}
				var length:uint=this._lib.readUnsignedInt();
				this._lib.readBytes(chunk.data,0,length);
				this._list.push(chunk);
				LIBDecoder._chunks[chunk.key]=chunk;
			}
			this.decodeNext();
		}
		
		private function decodeNext():void{
			if(this._list.length==0){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}else{
				var chunk:LIBChunk=this._list.shift();
				chunk.addEventListener(Event.COMPLETE,this.onChunkComplete);
				chunk.decode();
			}
		}
		
		private function onChunkComplete(event:Event):void{
			var chunk:LIBChunk=LIBChunk(event.currentTarget);
			chunk.removeEventListener(Event.COMPLETE,this.onChunkComplete);
			LIBDecoder._chunks[chunk.key]=chunk;
			this.decodeNext();
		}
		
		public function LIBDecoder(lib:ByteArray){
			this._lib=lib;
			this.readChunks();
		}
		
		public static function getCFGChunk(key:String):CFGChunk{
			var chunk:CFGChunk=LIBDecoder._chunks[key];
			return chunk;
		}
		
		public static function getSWFChunk(key:String):SWFChunk{
			var swfChunk:SWFChunk=LIBDecoder._chunks[key] as SWFChunk;
			if(!swfChunk)throw new LogError(key+" definition not find!");
			return swfChunk;
		}
	}
}