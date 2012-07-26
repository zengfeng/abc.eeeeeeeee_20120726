package gameui.data
{
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;

	import net.AssetData;

	public class GTabData extends GComponentData
	{
		public var upAsset : AssetData;
		public var overAsset : AssetData;
		public var disabledAsset : AssetData;
		public var selectedUpAsset : AssetData;
		public var selectedDisabledAsset : AssetData;
		public var labelData : GLabelData;
		public var textRollOverColor : uint;
		public var textSelectedColor : uint;
		public var selected : Boolean;
		public var padding : Number;
		public var gap : int;

		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : GTabData = source as GTabData;
			if (data == null) return;
			data.upAsset = upAsset;
			data.overAsset = overAsset;
			data.disabledAsset = disabledAsset;
			data.selectedUpAsset = selectedUpAsset;
			data.selectedDisabledAsset = selectedDisabledAsset;
			data.labelData = (labelData ? labelData.clone() : null);
			data.textRollOverColor = textRollOverColor;
			data.textSelectedColor = textSelectedColor;
			data.selected = selected;
			data.padding = padding;
		}

		public function GTabData()
		{
			init();
		}

		protected function init() : void
		{
			scaleMode = ScaleMode.AUTO_WIDTH;
			width = 60;
			height = 28;
			
			upAsset = new AssetData("GTab_upSkin");
			overAsset = new AssetData("GTab_overSkin");
			disabledAsset = new AssetData("GTab_disabledSkin");
			selectedUpAsset = new AssetData("GTab_selectedUpSkin");
			selectedDisabledAsset = new AssetData("GTab_selectedDisabledSkin");
			labelData = new GLabelData();
			labelData.textColor = 0x2f1f00;
			labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			labelData.textFieldFilters=[];
			textRollOverColor = 0x2f1f00;
			textSelectedColor = 0x2f1f00;
			selected = false;
			padding = 7;
			gap = 5;
		}

		override public function clone() : *
		{
			var data : GTabData = new GTabData();
			parse(data);
			return data;
		}
	}
}
