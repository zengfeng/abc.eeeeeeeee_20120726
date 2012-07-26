package bd {
	import core.IDispose;

	import gameui.controls.BDPlayer;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;

	public class BDData extends EventDispatcher implements IDispose {
		private var _list : Vector.<BDUnit>;
		private var _canDispose : Boolean = false;
		private var _playerList : Vector.<BDPlayer>;
		private var _key : int;

		public function BDData(value : Vector.<BDUnit>) {
			_list = value;
			_canDispose = false;
			_playerList = new Vector.<BDPlayer>();
		}

		public function set key(value : int) : void {
			_key = value;
		}

		public function getBDUnit(frame : int) : BDUnit {
			if (frame < 0 || frame >= _list.length) return null;
			return _list[frame];
		}

		public function addBDUnit(value : Vector.<BDUnit>) : void {
			if (!_list) _list = new Vector.<BDUnit>();
			_list = _list.concat(value);
		}

		public function list() : Vector.<BDUnit> {
			return _list;
		}

		public function addPlay(player : BDPlayer) : void {
			clearInterval(_num);
			_num=0;
			_playerList.push(player);
		}

		public function removePlay(player : BDPlayer) : void {
			for each (var play:BDPlayer in _playerList) {
				if (play === player) {
					var index : int = _playerList.indexOf(play);
					if (index >= 0)
						_playerList.splice(index, 1);
				}
			}
		}

		public function get total() : int {
			return _list.length;
		}

		private var _num : uint = 0;

		public function dispose() : void {
			if (_num) return;
			for each (var player:BDPlayer in _playerList) {
				if (player.data != this) {
					removePlay(player);
					continue;
				}
				if (player.isRun()) return;
				if (player.stage != null) return;

				if (!player.isDispose) return;
			}
			_num = setTimeout(requestDispose, 5 * 60 * 1000);
		}
		
		private function requestDispose():void
		{
			for each (var bds:BDUnit in _list) {
				bds.dispose();
			}
			_list.splice(0, _list.length);
			dispatchEvent(new Event("dispose"));
		}
	}
}