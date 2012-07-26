package net {
	import log4a.Logger;

	import utils.GStringUtil;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class SWFLoader extends RESLoader {
		private var _loader : Loader;
		private var _domain : ApplicationDomain;

		override protected function onComplete() : void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			var lc : LoaderContext = new LoaderContext();
			lc.allowCodeImport = true;
			_loader.loadBytes(_byteArray, lc);
		}

		private function completeHandler(event : Event) : void {
			_domain = LoaderInfo(event.currentTarget).applicationDomain;
			_isLoadding = false;
			_isLoaded = true;
			onByteArrayLoadComplete();
			
			if (isCache) {
				if (completeFun != null)
					completeFun(this);
				for each (var obj:Object in funArray)
					if ((obj["fun"] as Function) != null) (obj["fun"] as Function).apply(null, obj["params"]);
			} else {
				for each (obj in funArray)
					if ((obj["fun"] as Function) != null) (obj["fun"] as Function).apply(null, obj["params"]);
				if (completeFun != null)
					completeFun(this);
			}
		}

		protected function onByteArrayLoadComplete() : void {
		}

		override public function clear() : void {
			super.clear();
			if (_loader) {
				_loader.unloadAndStop(false);
			}
			funArray = [];
			if (!_isLoaded) {
				Logger.error("user stop!");
				if (errorFun != null)
					errorFun(this);
			}
			_isLoadding = false;
			_isLoaded = false;
			// ObjectPool.disposeObject(this, SWFLoader);
		}

		public function SWFLoader(data : LibData, fun : Function = null, onCompleteParams : Array = null) {
			super(data, fun, onCompleteParams);
		}

		override public function stop() : void {
			if (!_isLoadding && !_isLoaded) return;
		}

		public function getContent() : DisplayObject {
			return _loader.content;
		}

		public function getLoader() : Loader {
			return _loader;
		}

		public function getDomain() : ApplicationDomain {
			return _domain;
		}

		public function getClass(className : String) : Class {
			if (!_domain||!_domain.hasDefinition(className)) {
				Logger.error(GStringUtil.format("SWFLoader:{0} not find in {1}", className, _libData.url));
				return null;
			}
			var assetClass : Class = _domain.getDefinition(className) as Class;
			return assetClass;
		}

		public function getMovieClip(className : String) : MovieClip {
			var assetClass : Class = getClass(className);
			if (assetClass == null) return null;
			var mc : MovieClip = new assetClass() ;
			if (mc == null) {
				Logger.warn(GStringUtil.format("{0} isn't a MovieClip in {1}", className, _libData.url));
				return mc;
			}
			// mc.cacheAsBitmap = true;
			return mc;
		}

		public function getObj(className : String) : * {
			var assetClass : Class = getClass(className);
			if (assetClass == null) return null;
			var mc : * = new assetClass() ;
			if (mc == null) {
				Logger.warn(GStringUtil.format("{0} isn't a getObj in {1}", className, _libData.url));
				return mc;
			}
			return mc;
		}
	}
}