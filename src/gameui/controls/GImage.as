package gameui.controls {
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.layout.GLayout;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import utils.BDUtil;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class GImage extends GComponent {
		private var _bdPlayer : BDPlayer;
		protected var _data : GImageData;
		protected var _ioc : GIcon;
		protected var _loade : SWFLoader;

		public function GImage(data : GImageData) {
			this.mouseEnabled = false;
			_data = data;
			super(_data);
		}

		public function set url(url : String) : void {
			if (_data.libData && url == _data.libData.url) {
				return;
			}
			clearUp();
			if (url == "") return;
			_loaded = false;
			_data.libData = new LibData(url, url);
			create();
		}
		
		public function set libData(lib:LibData):void
		{
			if ((_data.libData && lib.url == _data.libData.url)||!lib) {
				return;
			}
			clearUp();
			_loaded = false;
			_data.libData = lib;
			create();
		}

		public function clearUp() : void {
			if (_ioc) {
				_ioc.hide();
			}
			if (_bdPlayer)
				_bdPlayer.hide();
			if (_loade) {
				var content : DisplayObject = _loade.getContent();
				if (content) {
					var parent : DisplayObjectContainer = _loade.getContent().parent;
					if (parent && (!(parent is Loader)))
						parent.removeChild(content);
				}
				RESManager.instance.remove(_loade.key, _data.force);
			}
			_data.libData = new LibData("");
		}

		public function dispose() : void {
			RESManager.instance.remove(_data.libData.key);
			if (_ioc) {
				_ioc.bitmapData = null;
				_ioc = null;
			}
			if (_bdPlayer)
				_bdPlayer.dispose();
		}

		override public function get height() : Number {
			if (_ioc != null) return _ioc.height;
			if (_bdPlayer != null) return _bdPlayer.height;
			return _height;
		}

		private var _componentData : GComponentData;

		override protected function create() : void {
			if (!_data.libData) return;
			_loade = RESManager.getLoader(_data.libData.key);
			if (!_componentData) _componentData = new GComponentData();
			_componentData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			if (_loade && _loade.getContent()) {
				addContent();
			} else
				addPrePlayer();
		}

		private function addContent() : void {
			if (_loade.getContent() is Bitmap) {
				if (!_ioc)
					_ioc = new GIcon(_data.iocData);
				_ioc.bitmapData = (_loade.getContent() as Bitmap).bitmapData;
				addChild(_ioc);
			} else if (_loade.getContent() is MovieClip) {
				if (!_data.isBDPlay) {
					if (_obj) {
						_loade.getContent()[_obj["name"]]([_obj["arg"]]);
					}
					addChild(_loade.getContent());
					GLayout.layout(_loade.getContent(), _data.iocData.align);
				} else {
					// if (!_bdPlayer)
					// {
					// _componentData.align = new GAlign(0, 0);
					// _bdPlayer = new BDPlayer(_componentData);
					// }
					// _bdPlayer.setBDData(BDUtil.toBDS(_data.classsName == "" ? _loade.getContent() as MovieClip : _loade.getMovieClip(_data.classsName)));
					// _bdPlayer.play(50, null, 0);
					// addChild(_bdPlayer);
				}
			}
			layout();
		}

		private function addPrePlayer() : void {
			if (_loaded) return;
			RESManager.instance.load(_data.libData, onComplete);
			if (!_data.showRing) return;
			if (!_bdPlayer)
				_bdPlayer = new BDPlayer(_componentData);
			_componentData.align=_data.align;
			_bdPlayer.setBDData(BDUtil.getBDData(new AssetData("MCLoading")));
			_bdPlayer.play(50, null, 0);
			addChild(_bdPlayer);
		}

		private var _obj : Object;

		public function mcText(funName : String, args : *) : void {
			_obj = {name:funName, arg:args};
			if (_loade && _loade.getContent() as MovieClip)
				_loade.getContent()[_obj["name"]]([_obj["arg"]]);
		}

		override protected function layout() : void {
			if (_bdPlayer) {
				GLayout.layout(_bdPlayer);
			}
			if (_ioc)
				GLayout.layout(_ioc);
			if (_data.autoLayout)
				GLayout.layout(this);
		}

		override public function hide() : void {
			super.hide();
			if (_bdPlayer){
				_bdPlayer.stop();
				_bdPlayer.hide();
			}
			clearUp();
		}

		override public function show() : void {
			super.show();
			create();
		}

		private var _loaded : Boolean = false;

		private function onComplete() : void {
			if (_bdPlayer)
				_bdPlayer.hide();
			_bdPlayer = null;
			_loaded = true;
			create();
			layout();
			dispatchEvent(new Event(Event.COMPLETE, true));
		}
	}
}
