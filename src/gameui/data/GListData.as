package gameui.data
{
	import gameui.cell.GCellData;
	import gameui.cell.GListCell;
	/**
	 * Game List Data
	 */
	public class GListData extends GPanelData {

		public var allowDrag : Boolean ;

		public var hGap : int;

		public var rows : int;

		public var cell : Class;

		public var cellData : GCellData;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GListData = source as GListData;
			if(data == null)return;
			data.allowDrag = allowDrag;
			data.hGap = hGap;
			data.rows = rows;
			data.cell = cell;
			data.cellData = cellData.clone();
		}

		public function GListData() {
			allowDrag = true;
			padding = 2;
			hGap = 1;
			rows = 5;
			cell = GListCell;
			cellData = new GCellData();
		}

		override public function clone() : * {
			var data : GListData = new GListData();
			parse(data);
			return data;
		}
	}
}
