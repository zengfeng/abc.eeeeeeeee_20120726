package lib
{
	import log4a.Logger;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.ApplicationDomain;


	public class SWFChunk extends LIBChunk {
		private var _loader : Loader;

		private var _domain : ApplicationDomain;

		private function completeHandler(event : Event) : void {
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.completeHandler);
			this._domain = LoaderInfo(event.currentTarget).applicationDomain;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		public function SWFChunk(key : String) {
			super(key, LIBChunk.SWF);
		}

		override public function decode() : void {
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
			this._loader.loadBytes(this._data);
		}

		public function getClass(className : String) : Class {
			if(!this._domain.hasDefinition(className)) {
				Logger.error(className + " definition not find in " + this.key);
				return null;
			}
			var assetClass : Class = this._domain.getDefinition(className) as Class;
			return assetClass;
		}

		public function getMovieClip(className : String) : MovieClip {
			var assetClass : Class = this.getClass(className);
			if(assetClass == null)return null;
			var mc : MovieClip = new assetClass() as MovieClip;
			if(mc == null)Logger.error(className + " isn't a MovieClip in " + this.key);
			return mc;
		}
	}
}