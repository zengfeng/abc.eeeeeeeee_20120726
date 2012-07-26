package  gameui.drag {
	import flash.display.DisplayObject;

	public class DragData {

		private var _owner : IDragTarget;

		private var _source : IDragItem;
		
		public var dragSource:IDragSource;
		
		public var dragItem:Object;

		public var state : int;

		public var s_place : int;

		public var s_gird : int;

		public var target : IDragItem;

		public var t_place : int;

		public var t_gird : int;

		public var split : IDragItem;

		public var splitCount : int;

		public var hitTarget : DisplayObject;

		public var stageX : int;

		public var stageY : int;
		
		public var offsetX:int;
		
		public var offsetY:int;
		
		public var isAuto:Boolean=true;
		
		public var callBack:Function;
		
		public function DragData() {
		}

		public function reset(owner : IDragTarget,source : IDragItem) : void {
			_owner = owner;
			_source = source;
			s_place = source.place;
			s_gird = source.gird;
			target = null;
			t_place = -1;
			t_gird = -1;
			split = null;
			splitCount = 0;
			state = DragState.REMOVE;
		}

		public function get owner() : IDragTarget {
			return _owner;
		}

		public function get source() : IDragItem {
			return _source;
		}
		
		public function set owner(value:IDragTarget):void
		{
			_owner=value;
		}
	}
}
