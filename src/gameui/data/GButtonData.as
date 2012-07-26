package gameui.data {
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	/**
	 * Game Button Data
	 */
	public class GButtonData extends GComponentData {
		public var upAsset : AssetData;
		public var overAsset : AssetData;
		public var downAsset : AssetData;
		public var disabledAsset : AssetData;
		public var labelData : GLabelData;
		public var isHtmlColor : Boolean = false;
		public var disabledColor : uint = 0x999999;
		public var rollOverColor : uint = 0xFFFFFF;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GButtonData = source as GButtonData;
			if (data == null) return;
			data.upAsset = upAsset;
			data.overAsset = overAsset;
			data.downAsset = downAsset;
			data.disabledAsset = disabledAsset;
			data.labelData = (labelData ? labelData.clone() : null);
			data.disabledColor = disabledColor;
			data.rollOverColor = rollOverColor;
		}

		public function GButtonData() {
			upAsset = new AssetData(SkinStyle.button_upSkin);
			overAsset = new AssetData(SkinStyle.button_overSkin);
			downAsset = new AssetData(SkinStyle.button_downSkin);
			disabledAsset = new AssetData(SkinStyle.button_disabledSkin);
			width = 70;
			height = 24;
			labelData = new GLabelData();
			labelData.wordWrap=false;
			labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
		}

		override public function clone() : * {
			var data : GButtonData = new GButtonData();
			parse(data);
			return data;
		}
	}
}
