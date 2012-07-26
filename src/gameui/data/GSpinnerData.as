package  gameui.data {


	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;

	import net.AssetData;
	public class GSpinnerData extends GComponentData {

		public var upArrowData : GButtonData;

		public var downArrowData : GButtonData;

		public var textInputData : GTextInputData;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GSpinnerData = source as GSpinnerData;
			if(data == null)return;
			data.upArrowData = (upArrowData ? upArrowData.clone() : null);
			data.downArrowData = (downArrowData ? downArrowData.clone() : null);
			data.textInputData = (textInputData ? textInputData.clone() : null);
		}

		public function GSpinnerData() {
			upArrowData = new GButtonData();
			upArrowData.upAsset = new AssetData("GSpinner_upArrow_upSkin");
			upArrowData.overAsset = new AssetData("GSpinner_upArrow_overSkin");
			upArrowData.downAsset = new AssetData("GSpinner_upArrow_downSkin");
			upArrowData.disabledAsset = new AssetData("GSpinner_upArrow_disabledSkin");
			upArrowData.scaleMode = ScaleMode.SCALE_NONE;
			upArrowData.width = 18;
			upArrowData.height = 11;
			downArrowData = new GButtonData();
			downArrowData.upAsset = new AssetData("GSpinner_downArrow_upSkin");
			downArrowData.overAsset = new AssetData("GSpinner_downArrow_overSkin");
			downArrowData.downAsset = new AssetData("GSpinner_downArrow_downSkin");
			downArrowData.disabledAsset = new AssetData("GSpinner_downArrow_disabledSkin");
			downArrowData.scaleMode = ScaleMode.SCALE_NONE;
			downArrowData.width = 18;
			downArrowData.height = 11;
			textInputData = new GTextInputData();
			scaleMode = ScaleMode.AUTO_WIDTH;
			width = 70;
			height = 22;
		}

		override public function clone() : * {
			var data : GSpinnerData = new GSpinnerData();
			parse(data);
			return data;
		}
	}
}
