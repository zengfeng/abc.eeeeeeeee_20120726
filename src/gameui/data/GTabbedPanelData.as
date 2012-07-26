package  gameui.data {
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;
	
	public class GTabbedPanelData extends GComponentData {

		public var tabData : GTabData;

		public var viewStackData : GComponentData;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GTabbedPanelData = source as GTabbedPanelData;
			if(data == null)return;
			data.tabData = (tabData ? tabData.clone() : null);
			data.viewStackData = (viewStackData ? viewStackData.clone() : null);
		}

		public function GTabbedPanelData() {
			tabData = new GTabData();
			viewStackData = new GComponentData();
			scaleMode = ScaleMode.AUTO_SIZE;
			width = 200;
			height = 200;
		}

		override public function clone() : * {
			var data : GTabbedPanelData = new GTabbedPanelData();
			parse(data);
			return data;
		}
	}
}
