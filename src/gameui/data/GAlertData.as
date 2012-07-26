package  gameui.data {


	import gameui.core.GAlign;
	import gameui.core.ScaleMode;
	import gameui.manager.UIManager;

	import net.AssetData;
	/**
	 * Game Alert Data
	 * 
	 */
	public class GAlertData extends GPanelData {

		public var labelData : GLabelData;

		public var textInputData : GTextInputData;

		public var buttonData : GButtonData;

		public var flag : uint = 0x4;

		public var okLabel : String = "<b>确定</b>";

		public var cancelLabel : String = "<b>取消</b>";

		public var yesLabel : String = "<b>是</b>";

		public var noLabel : String = "<b>否</b>";

		public var hgap : int = 10;

		public var vgap : int = 10;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GAlertData = source as GAlertData;
			if(data == null)return;
			data.labelData = labelData.clone();
			data.textInputData = (textInputData ? textInputData.clone() : null);
			data.buttonData = buttonData.clone();
			data.flag = flag;
			data.okLabel = okLabel;
			data.cancelLabel = cancelLabel;
			data.yesLabel = yesLabel;
			data.noLabel = noLabel;
			data.hgap = hgap;
			data.vgap = vgap;
		}

		public function GAlertData() {
			bgAsset = new AssetData("GPanel_backgroundSkin");
			modal = true;
			scaleMode = ScaleMode.AUTO_SIZE;
			align = GAlign.CENTER;
			padding = 10;
			minWidth = 150;
			minHeight = 60;
			labelData = new GLabelData();
			labelData.textFieldFilters = UIManager.getEdgeFilters(0x000000, 0.7);
			buttonData = new GButtonData();
			buttonData.width = 60;
		}

		override public function clone() : * {
			var data : GAlertData = new GAlertData();
			parse(data);
			return data;
		}
	}
}
