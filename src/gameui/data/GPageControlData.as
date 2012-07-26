package  gameui.data {
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	public class GPageControlData extends GComponentData {

		public var prev_buttonData : GButtonData;

		public var next_buttonData : GButtonData;

		public var labelData : GLabelData;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GPageControlData = source as GPageControlData;
			if(data == null)return;
			data.prev_buttonData = (prev_buttonData == null ? null : prev_buttonData.clone());
			data.next_buttonData = (next_buttonData == null ? null : next_buttonData.clone());
			data.labelData = (labelData == null ? null : labelData.clone());
		}

		public function GPageControlData() {
			width = 150;
			height = 24;
			prev_buttonData = new GButtonData();
			prev_buttonData.width = 50;
			prev_buttonData.align = new GAlign(0, -1, -1, -1, -1, 0);
			prev_buttonData.labelData.text = "上一页";
			next_buttonData = new GButtonData();
			next_buttonData.width = 50;
			next_buttonData.align = new GAlign(-1, 0, -1, -1, -1, 0);
			next_buttonData.labelData.text = "下一页";
			labelData = new GLabelData();
			labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			labelData.text = "1/1";
		}

		override public function clone() : * {
			var data : GPageControlData = new GPageControlData();
			parse(data);
			return data;
		}
	}
}