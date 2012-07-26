package gameui.data
{
	import gameui.core.GComponentData;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	public class GCheckBoxData extends GComponentData
	{
		public var upAsset : AssetData;
		public var upIcon : AssetData;
		public var selectedUpIcon : AssetData;
		public var labelData : GLabelData = new GLabelData();
		public var selected : Boolean = false;
		public var padding : int = 2;
		public var hGap : int = 3;

		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : GCheckBoxData = source as GCheckBoxData;
			if (data == null) return;
			data.upAsset = upAsset;
			data.upIcon = upIcon;
			data.selectedUpIcon = selectedUpIcon;
			data.labelData = labelData.clone();
			data.selected = selected;
			data.hGap = hGap;
			data.padding = padding;
		}

		public function GCheckBoxData()
		{
			upAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			upIcon = new AssetData(SkinStyle.checkBox_upIcon);
			selectedUpIcon = new AssetData(SkinStyle.checkBox_selectedUpIcon);
			labelData.textColor = 0x2F1F00;
			labelData.textFieldFilters = [];
			width = 70;
			height = 18;
		}

		override public function clone() : *
		{
			var data : GCheckBoxData = new GCheckBoxData();
			parse(data);
			return data;
		}
	}
}
