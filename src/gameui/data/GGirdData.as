package  gameui.data {
	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.controls.GAlert;
	import gameui.core.ScaleMode;
	import gameui.manager.UIManager;
	public class GGirdData extends GPanelData {

		public var allowDrag : Boolean = false;

		public var hgap : int = 2;

		public var vgap : int = 2;

		public var columns : int = 3;

		public var rows : int = 3;

		public var cell : Class = GCell;

		public var cellData : GCellData = new GCellData();

		public var alertData : GAlertData;

		public var hotKeys : Array;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GGirdData = source as GGirdData;
			if(data == null)return;
			data.allowDrag = allowDrag;
			data.hgap = hgap;
			data.vgap = vgap;
			data.columns = columns;
			data.rows = rows;
			data.cell = cell;
			data.cellData = cellData.clone();
			data.alertData = alertData.clone();
		}

		public function GGirdData() {
			alertData = new GAlertData();
			alertData.parent = UIManager.root;
		//	alertData.labelData.iconData.bitmapData = BDUtil.getBD(new AssetData("light_22"));
			alertData.flag = GAlert.YES | GAlert.NO;
			scaleMode = ScaleMode.AUTO_SIZE;
		}

		override public function clone() : * {
			var data : GGirdData = new GGirdData();
			parse(data);
			return data;
		}
	}
}
