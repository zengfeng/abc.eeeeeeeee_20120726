package net {
	import flash.events.EventDispatcher;

	/**
	 * @author yangyiqiang
	 */
	public class PreloadModel extends EventDispatcher {
		public static const MAX : int = 2;
		private var _loaderV : Vector.<ALoader>=new Vector.<ALoader>();
		private var _loadIng : Vector.<ALoader>=new Vector.<ALoader>();
		private var _loaderPre : Vector.<ALoader>=new Vector.<ALoader>();
		private var _preLoadIng : Vector.<ALoader>=new Vector.<ALoader>();
		/**
		 * 状态
		 * 0: 正常
		 * 1: 暂停
		 */
		private var _state : int = 0;

		public function add(loader : ALoader) : void {
			_loaderV.push(loader);
			if (_loadIng.length < MAX) loadNext();
		}

		public function remove(loader : ALoader) : void {
			if (!loader) return;
			loader.stop();
			var index : int = _loaderV.indexOf(loader);
			if (index >= 0) {
				_loaderV.splice(index, 1);
			} else {
				index = _loadIng.indexOf(loader);
				if (index >= 0) {
					_loadIng.splice(index, 1) as ALoader;
				}
				loadNext();
			}
			removePre(loader.key);
		}

		public function addPre(loader : ALoader) : void {
			_loaderPre.push(loader);
			if (_state == 0 && _loadIng.length == 0) resumePre();
		}

		public function removePre(key : String) : void {
			for (var i : int = 0;i < _preLoadIng.length;i++) {
				if (_preLoadIng[i].key == key) {
					_preLoadIng[i].stop();
					_preLoadIng.splice(i, 1);
					break;
				}
			}
			for (i = 0;i < _loaderPre.length;i++) {
				if (_loaderPre[i].key == key) {
					_loaderPre[i].stop();
					_loaderPre.splice(i, 1);
					break;
				}
			}
			if (_preLoadIng.length < MAX)
				loadPre();
		}

		private function loadNext() : void {
			if (_loaderV.length == 0) {
				resumePre();
				return;
			}
			pausePre();
			_loadIng[_loadIng.push(_loaderV.shift()) - 1].load();
		}

		private function loadPre() : void {
			if (_loaderPre.length > 0 && _preLoadIng.length < MAX) {
				_preLoadIng[_preLoadIng.push(_loaderPre.shift()) - 1].load();
			}
		}

		public function pausePre() : void {
			for each (var loader:ALoader in _preLoadIng)
				loader.stop();
		}

		public function resumePre() : void {
			if (_state == 1) return;
			if (_loaderV.length > 0) return;
			if (_preLoadIng.length < MAX) {
				loadPre();
				return;
			}
			for each (var loade:ALoader in _preLoadIng)
				loade.load();
		}

		public function pause() : void {
			if (_state == 1) return;
			_state = 1;
			pausePre();
			for each (var loader:ALoader in _loadIng)
				loader.stop();
		}

		public function resume() : void {
			if (_state != 1) return;
			if (_loadIng.length == 0) {
				loadNext();
				return;
			}
			for each (var loade:ALoader in _loadIng)
				loade.load();
		}
	}
}
