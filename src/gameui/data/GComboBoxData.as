package gameui.data
{
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	public class GComboBoxData extends GComponentData
	{
		public var buttonData : GButtonData;
		public var textInputData : GTextInputData;
		public var arrow : GButtonData;
		public var listData : GListData;
		public var editable : Boolean = false;

		public function GComboBoxData()
		{
			buttonData = new GButtonData();
			buttonData.upAsset = new AssetData("GComboBox_upSkin");
			buttonData.overAsset = new AssetData("GComboBox_overSkin");
			buttonData.downAsset = new AssetData("GComboBox_downSkin");
			buttonData.disabledAsset = new AssetData("GComboBox_disabledSkin");
			buttonData.labelData.textFieldFilters = [];
			buttonData.labelData.textColor = 0x2F1F00;
			buttonData.labelData.align = new GAlign(8, -1, -1, -1, -1, 0);
			textInputData = new GTextInputData();
			arrow = new GButtonData();
			arrow.upAsset = new AssetData("GComboBox_arrowUpSkin");
			arrow.overAsset = new AssetData("GComboBox_arrowOverSkin");
			arrow.downAsset = new AssetData("GComboBox_arrowDownSkin");
			arrow.disabledAsset = new AssetData("GComboBox_arrowDisabledSkin");
			arrow.width = 18;
			arrow.height = 22;
			listData = new GListData();
			listData.cellData.selected_upAsset = new AssetData(SkinStyle.emptySkin);
			listData.cellData.upAsset = new AssetData(SkinStyle.emptySkin);
			listData.scaleMode = ScaleMode.AUTO_HEIGHT;
			listData.horizontalScrollPolicy = GPanelData.OFF;
			width = 100;
			height = 22;
		}
	}
}
