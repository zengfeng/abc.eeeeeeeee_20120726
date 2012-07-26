package  gameui.data {


	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	public class GToggleButtonData extends GComponentData {

		public var upAsset : AssetData;

		public var overAsset : AssetData;

		public var downAsset : AssetData;

		public var disabledAsset : AssetData;

		public var selectedUpAsset : AssetData;

		public var selectedOverAsset : AssetData;

		public var selectedDownAsset : AssetData;

		public var selectedDisabledAsset : AssetData;

		public var labelData : GLabelData;

		public var selected : Boolean = false;

		public var disabledColor : uint = 0x787878;

		public var textRollOverColor : uint = 0xFFFFFF;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GToggleButtonData = source as GToggleButtonData;
			if(data == null)return;
			data.upAsset = upAsset;
			data.overAsset = overAsset;
			data.downAsset = downAsset;
			data.disabledAsset = disabledAsset;
			data.selectedUpAsset = selectedUpAsset;
			data.selectedOverAsset = selectedOverAsset;
			data.selectedDownAsset = selectedDownAsset;
			data.selectedDisabledAsset = selectedDisabledAsset;
			data.labelData = (labelData ? labelData.clone() : null);
			data.disabledColor = disabledColor;
			data.textRollOverColor = textRollOverColor;
			data.selected = selected;
		}

		public function GToggleButtonData() {
			upAsset = new AssetData(SkinStyle.button_upSkin);
			overAsset = new AssetData(SkinStyle.button_overSkin);
			downAsset = new AssetData(SkinStyle.button_downSkin);
			disabledAsset = new AssetData(SkinStyle.button_disabledSkin);
			selectedUpAsset = new AssetData(SkinStyle.button_selectedUpSkin);
			selectedOverAsset = new AssetData(SkinStyle.button_selectedOverSkin);
			selectedDownAsset = new AssetData(SkinStyle.button_selectedDownSkin);
			selectedDisabledAsset = new AssetData(SkinStyle.button_selectedDisabledSkin);
			width = 70;
			height = 24;
			labelData = new GLabelData();
			labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
		}

		override public function clone() : * {
			var data : GToggleButtonData = new GToggleButtonData();
			parse(data);
			return data;
		}
	}
}
