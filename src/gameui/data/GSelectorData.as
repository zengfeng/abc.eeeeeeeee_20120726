package  gameui.data {


	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	public class GSelectorData extends GComponentData {

		public var prev_buttonData : GButtonData;

		public var next_buttonData : GButtonData;

		public var labelData : GLabelData = new GLabelData();

		public var content : Class = GComponent;

		public var componentData : GComponentData = new GComponentData();

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GSelectorData = source as GSelectorData;
			if(data == null)return;
			data.prev_buttonData = prev_buttonData;
			data.next_buttonData = next_buttonData;
			data.labelData = labelData;
			data.content = content;
			data.componentData = componentData.clone();
		}

		public function GSelectorData() {
			prev_buttonData = new GButtonData();
//			prev_buttonData.labelData.iconData.asset = new AssetData("GSelector_prevIcon");
			prev_buttonData.width = 19;
			prev_buttonData.height = 19;
			next_buttonData = new GButtonData();
//			next_buttonData.labelData.iconData.asset = new AssetData("GSelector_nextIcon");
			next_buttonData.align = new GAlign(-1, 0, -1, -1, -1, 0);
			next_buttonData.width = 19;
			next_buttonData.height = 19;
			content = GLabel;
			componentData = new GLabelData();
			width = 80;
			height = 20;
		}

		override public function clone() : * {
			var data : GSelectorData = new GSelectorData();
			parse(data);
			return data;
		}
	}
}
