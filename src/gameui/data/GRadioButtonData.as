package gameui.data {
	import gameui.core.GComponentData;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	public class GRadioButtonData extends GComponentData {
		public var upAsset : AssetData;
		public var upIcon : AssetData;
		public var overIcon : AssetData;
		public var selectedUpIcon : AssetData;
		public var labelData : GLabelData;
		public var iconData : GIconData;
		public var selected : Boolean = false;
		public var padding : int = 0;
		public var hGap : int = 0;
		public var isHtmlColor : Boolean = false;
		public var disabledColor : uint = 0x898989;
		public var color : uint = 0xFFFFFF;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GRadioButtonData = source as GRadioButtonData;
			if (data == null) return;
			data.upAsset = upAsset;
			data.overIcon = overIcon;
			data.upIcon = upIcon;
			data.selectedUpIcon = selectedUpIcon;
			data.labelData = labelData.clone();
			data.selected = selected;
			data.padding = padding;
			data.hGap = hGap;
			data.iconData = iconData;
		}

		public function GRadioButtonData() {
			upAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			upIcon = new AssetData(SkinStyle.radioButton_upIcon);
			// overIcon = new AssetData(SkinStyle.radioButton_upIcon);
			selectedUpIcon = new AssetData(SkinStyle.radioButton_selectedUpIcon);
			labelData = new GLabelData();
			width = 70;
			height = 18;
			iconData = new GIconData();
		}

		override public function clone() : * {
			var data : GRadioButtonData = new GRadioButtonData();
			parse(data);
			return data;
		}
	}
}
